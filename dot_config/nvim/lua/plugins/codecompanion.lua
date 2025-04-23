-- Helper function to merge options
local function merge_opts(defaults, opts)
	return vim.tbl_deep_extend("force", defaults, opts or {})
end

-- Reusable keymaps for CodeCompanion
local codecompanion_keymaps = {
	close = { modes = { n = "q" } },
	stop = { modes = { n = "<Esc>" } },
	send = { modes = { n = "<CR>" } },
}

-- Reusable roles for CodeCompanion
local function get_codecompanion_roles()
	local user = vim.env.USER or "Beowulf"
	return {
		llm = "  CodeCompanion",
		user = "  " .. user,
	}
end

return {
	-- CodeCompanion plugin configuration
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = {
			"CodeCompanion",
			"CodeCompanionActions",
			"CodeCompanionChat",
		},
		opts = function(_, opts)
			return merge_opts(opts, {
				strategies = {
					chat = {
						roles = get_codecompanion_roles(),
						keymaps = codecompanion_keymaps,
					},
				},
			})
		end,
		keys = {
			{ "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
			{
				"<leader>ap",
				"<cmd>CodeCompanionActions<cr>",
				mode = { "n", "v" },
				desc = "Prompt Actions (CodeCompanion)",
			},
			{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle (CodeCompanion)" },
			{ "<leader>ai", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline prompt (CodeCompanion)" },
		},
	},

	-- Edgy.nvim plugin configuration
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "codecompanion",
				title = "CodeCompanion Chat",
				size = { width = 60 },
			})
		end,
	},

	-- Blink.cmp plugin configuration
	{
		"saghen/blink.cmp",
		lazy = true,
		opts = {
			sources = {
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
			},
		},
	},
}
