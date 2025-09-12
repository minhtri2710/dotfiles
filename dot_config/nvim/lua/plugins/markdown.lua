return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			completions = {
				lsp = {
					enabled = true,
				},
				blink = {
					enabled = true,
				},
			},
			block = {
				sign = true,
			},
			heading = {
				sign = true,
				position = "inline",
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			checkbox = {
				enabled = true,
				unchecked = { icon = "✘ " },
				checked = { icon = "✔ ", scope_highlight = "@markup.strikethrough" },
				custom = { todo = { rendered = "◯ " } },
			},
		},
	},
	{
		"tadmccorkle/markdown.nvim",
		ft = "markdown",
		keys = {},
		opts = {},
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
		version = "*",
		opts = {
			workspaces = {
				{
					name = "SecondBrain",
					path = "~/second-brain",
					overrides = {
						notes_subdir = "notes",
					},
				},
			},
			daily_notes = {
				folder = "notes/dailies",
			},
			open_notes_in = "vsplit",
			checkbox = {
				order = { " ", "x" },
			},
		},
	},
}
