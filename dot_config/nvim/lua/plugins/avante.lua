return {
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		opts = {
			-- Default configuration
			hints = { enabled = false },

			-- File selector configuration
			--- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
			file_selector = {
				provider = "snacks",
				provider_opts = {},
			},
		},
		build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
	},
	{
		"saghen/blink.cmp",
		lazy = true,
		dependencies = { "saghen/blink.compat" },
		opts = {
			sources = {
				default = { "avante_commands", "avante_mentions", "avante_files" },
				compat = {
					"avante_commands",
					"avante_mentions",
					"avante_files",
				},
				-- LSP score_offset is typically 60
				providers = {
					avante_commands = {
						name = "avante_commands",
						module = "blink.compat.source",
						score_offset = 90,
						opts = {},
					},
					avante_files = {
						name = "avante_files",
						module = "blink.compat.source",
						score_offset = 100,
						opts = {},
					},
					avante_mentions = {
						name = "avante_mentions",
						module = "blink.compat.source",
						score_offset = 1000,
						opts = {},
					},
				},
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "Avante" },
		opts = {
			file_types = {
				"Avante",
			},
		},
	},
}
