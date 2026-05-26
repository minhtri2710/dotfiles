-- Set default search directories for todo lists
vim.g.markdown_todo_dirs = vim.g.markdown_todo_dirs or { "~/second-brain/notes/dailies" }

-- Custom picker for markdown todo lists
local function search_todos(status)
	local dirs = vim.g.markdown_todo_dirs

	if type(dirs) == "string" then
		dirs = { dirs }
	end

	-- Expand paths
	local expanded_dirs = {}
	for _, dir in ipairs(dirs) do
		local expanded = vim.fn.expand(dir)
		table.insert(expanded_dirs, expanded)
	end

	-- Build ripgrep pattern for different todo formats
	-- Supports: - [ ], - [x], TODO:, DONE:, etc.
	local pattern
	local title

	if status == "done" then
		-- Match: - [x], - [X], DONE:
		pattern = "(^\\s*-\\s*\\[[xX]\\])|(^\\s*DONE:)"
		title = "✓ Done Tasks"
	elseif status == "todo" then
		-- Match: - [ ], TODO:, - TODO
		pattern = "(^\\s*-\\s*\\[\\s\\])|(^\\s*TODO:)|(^\\s*-\\s*TODO)"
		title = "☐ Todo Tasks"
	else
		-- All todos: checkboxes + TODO/DONE keywords
		pattern = "(^\\s*-\\s*\\[[\\sxX]\\])|(^\\s*(TODO|DONE):)|(^\\s*-\\s*TODO)"
		title = "☑ All Todos"
	end

	Snacks.picker.grep({
		title = title,
		search = pattern,
		regex = true,
		live = false,
		args = {
			"--type=md",
			"--trim",
		},
		dirs = expanded_dirs,
		confirm = function(picker, item)
			picker:close()
			vim.cmd("vsplit " .. vim.fn.fnameescape(item.file))
			if item.pos and item.pos[1] then
				vim.api.nvim_win_set_cursor(0, { item.pos[1], 0 })
			end
		end,
		formatters = {
			file = {
				filename_only = true,
			},
		},
	})
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		opts = {
			completions = {
				lsp = {
					enabled = true,
				},
				blink = {
					enabled = true,
				},
			},
			code = {
				sign = true,
			},
			heading = {
				sign = true,
				position = "inline",
			},
			checkbox = {
				enabled = true,
				unchecked = { icon = "✘ " },
				checked = { icon = "✔ ", scope_highlight = "@markup.strikethrough" },
				custom = { todo = { rendered = "◯ " } },
			},
		},
		config = function(_, opts)
			-- call the plugin setup with the opts
			local ok, rm = pcall(require, "render-markdown")
			if ok and type(rm.setup) == "function" then
				rm.setup(opts)
			end

			-- ensure tree-sitter highlighter is started for markdown buffers
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "markdown",
				callback = function(args)
					local bufnr = args.buf
					local okp, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
					if okp and parser then
						pcall(vim.treesitter.start, bufnr, "markdown")
					end
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				marksman = {
					enabled = false,
				},
			},
			setup = {
				markdown_oxide = function(_, opts)
					LazyVim.lsp.on_attach(function(client, bufnr)
						local function check_codelens_support()
							if client.server_capabilities.codeLensProvider then
								return true
							end
							return false
						end

						vim.api.nvim_create_autocmd(
							{ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" },
							{
								buffer = bufnr,
								callback = function()
									if check_codelens_support() then
										vim.lsp.codelens.refresh({ bufnr = bufnr })
									end
								end,
							}
						)
						vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
					end)
				end,
			},
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		lazy = false,
		keys = {
			{
				"<leader>N",
				":vsplit | Obsidian today<Return>",
				desc = "Open today's note in Obsidian",
				mode = "n",
			},
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "SecondBrain",
					path = "~/second-brain",
				},
			},
			daily_notes = {
				folder = "dailies",
			},
			checkbox = {
				create_new = true,
				order = { " ", "x" },
			},
			ui = {
				enable = false,
			},
		},
	},
	{
		"yousefhadder/markdown-plus.nvim",
		event = "BufReadPost",
		ft = "markdown",
		opts = {},
	},
	{
		"folke/snacks.nvim",
		keys = {
			{
				"<leader>mt",
				function()
					search_todos("todo")
				end,
				desc = "Markdown: Search Todo Items",
			},
			{
				"<leader>md",
				function()
					search_todos("done")
				end,
				desc = "Markdown: Search Done Items",
			},
			{
				"<leader>ma",
				function()
					search_todos("all")
				end,
				desc = "Markdown: Search All Todos",
			},
		},
	},
}
