return {
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "Obsidian",
					path = function()
						if (vim.fn.has("win32")) == 1 then
							return "C:\\Users\\tri.tran\\Downloads\\Obsidian\\Beowulf"
						end

						return "~/Documents/Obsidian Vault/"
					end,
				},
			},
			ui = {
				enable = false,
			},
		},
	},
}
