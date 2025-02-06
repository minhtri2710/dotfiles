return {
	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(keys, {
				{
					"gd",
					function()
						require("telescope.builtin").lsp_definitions({ reuse_win = false })
					end,
					desc = "Goto Definition",
					has = "definition",
				},
			})

			return vim.tbl_deep_extend("force", opts, {
				inlay_hints = { enabled = false },
				---@type lspconfig.options
				servers = {
					emmet_language_server = {
						filetypes = {
							"phtml",
						},
					},
					html = {
						filetypes = { "phtml" },
					},
				},
			})
		end,
	},

	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters = {
				phpcs = {
					args = {
						"-q",
						"--standard=PSR12",
						"--exclude=Generic.WhiteSpace.DisallowTabIndent,Squiz.Functions.MultiLineFunctionDeclaration,PSR2.Classes.ClassDeclaration",
						"--report=json",
						"-",
					},
				},
			},
		},
	},

	{
		{
			"stevearc/conform.nvim",
			optional = true,
			opts = {
				default_format_opts = {
					timeout_ms = 10000,
				},
				formatters_by_ft = {
					css = {
						"prettier",
						"stylelint",
					},
				},
			},
		},
	},
}
