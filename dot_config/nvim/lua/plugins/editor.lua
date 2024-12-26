return {
	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {
			highlighters = {
				hsl_color = {
					pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
					group = function(_, match)
						local MiniHipatterns = require("mini.hipatterns")
						local utils = require("solarized-osaka.hsl")
						--- @type string, string, string
						local nh, ns, nl = match:match("hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)")
						--- @type number?, number?, number?
						local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
						--- @type string
						local hex_color = utils.hslToHex(h, s, l)
						return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
					end,
				},
			},
		},
	},
	{
		"ibhagwan/fzf-lua",
		keys = {
			{
				"<leader>fP",
				function()
					require("fzf-lua").files({
						cwd = require("lazy.core.config").options.root,
					})
				end,
				desc = "Find Plugin File",
			},
			{
				";f",
				function()
					require("fzf-lua").files({
						no_ignore = false,
						hidden = true,
						previewer = false,
					})
				end,
				desc = "Lists files in your current working directory, respects .gitignore",
			},
			{
				";s",
				function()
					require("fzf-lua").grep({ search = vim.fn.input("Grep > ") })
				end,
				desc = "Grep string",
			},
			{
				";r",
				function()
					require("fzf-lua").live_grep({
						additional_args = { "--hidden" },
					})
				end,
				desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
			},
			{
				"\\\\",
				function()
					require("fzf-lua").buffers()
				end,
				desc = "Lists open buffers",
			},
			{
				";h",
				function()
					require("fzf-lua").helptags()
				end,
				desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
			},
			{
				";;",
				function()
					require("fzf-lua").resume()
				end,
				desc = "Resume the previous telescope picker",
			},
			{
				";e",
				function()
					require("fzf-lua").diagnostics_workspace()
				end,
				desc = "Lists Diagnostics for all open buffers or a specific buffer",
			},
			{
				";t",
				function()
					require("fzf-lua").treesitter()
				end,
				desc = "Lists Function names, variables, from Treesitter",
			},
			{
				";g",
				function()
					require("fzf-lua").git_files()
				end,
				desc = "Lists git files",
			},
			{
				";b",
				function()
					require("fzf-lua").git_branches()
				end,
				desc = "List git branches",
			},
		},
	},
	{
		"telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
			"ThePrimeagen/git-worktree.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
			"debugloop/telescope-undo.nvim",
			"nvim-telescope/telescope-frecency.nvim",
		},
		keys = {
			{
				"sf",
				function()
					local function telescope_buffer_dir()
						return vim.fn.expand("%:p:h")
					end

					require("telescope").extensions.file_browser.file_browser({
						path = "%:p:h",
						cwd = telescope_buffer_dir(),
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						initial_mode = "normal",
						layout_config = { height = 40 },
					})
				end,
				desc = "Open File Browser with the path of the current buffer",
			},
			{
				"<leader>gw",
				function()
					require("telescope").extensions.git_worktree.git_worktrees()
				end,
				desc = "List git worktree",
			},
			{
				"<leader>fg",
				function()
					require("telescope").extensions.live_grep_args.live_grep_args()
				end,
				desc = "Live grep with args",
			},
			{
				";p",
				function()
					require("telescope").extensions.pomodori.timers()
				end,
				desc = "Manage pomodori timers",
			},
			{
				";u",
				function()
					require("telescope").extensions.undo.undo()
				end,
				desc = "Manage undo",
			},
			{
				"<leader>sf",
				function()
					require("telescope").extensions.frecency.frecency()
				end,
				desc = "Frecency",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions
			local fb_config = require("telescope").extensions.file_browser.config

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
			})
			opts.pickers = {
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
				buffers = {
					mappings = {
						n = {
							["d"] = actions.delete_buffer,
						},
					},
				},
			}
			opts.extensions = {
				file_browser = {
					-- disables netrw and use telescope-file-browser in its place
					hijack_netrw = true,
					mappings = {
						-- your custom insert mode mappings
						["n"] = {
							-- your custom normal mode mappings
							["N"] = fb_actions.create,
							["h"] = fb_actions.goto_parent_dir,
							["/"] = function()
								vim.cmd("startinsert")
							end,
							["<C-u>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<C-d>"] = function(prompt_bufnr)
								for i = 1, 10 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
							["<PageUp>"] = actions.preview_scrolling_up,
							["<PageDown>"] = actions.preview_scrolling_down,
						},
					},
				},
				undo = {
					side_by_side = true,
					layout_strategy = "vertical",
					layout_config = {
						preview_height = 0.8,
					},
				},
			}
			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")
			telescope.load_extension("git_worktree")
			telescope.load_extension("live_grep_args")
			telescope.load_extension("pomodori")
			telescope.load_extension("undo")
			telescope.load_extension("frecency")
		end,
	},
	{
		"preservim/vim-pencil",
	},
	{
		"saghen/blink.cmp",
		opts = {
			completion = {
				menu = {
					winblend = vim.o.pumblend,
				},
				documentation = {
					window = {
						winblend = vim.o.pumblend,
					},
				},
			},
			signature = {
				window = {
					winblend = vim.o.pumblend,
				},
			},
		},
	},
}
