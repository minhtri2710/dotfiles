return {
	{
		"kawre/leetcode.nvim",
		cmd = "Leet",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			plugins = {
				non_standalone = false,
			},
		},
	},
}
