return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "aura-ultra",
		},
	},
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "storm",
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_highlights = function(hl)
				hl.LineNr = { fg = "#ba34d1" }
				hl.LineNrAbove = { fg = "#ba34d1" }
				hl.LineNrBelow = { fg = "#a434eb" }
			end,
		},
	},
	{
		"minhtri2710/aura-ultra.nvim",
		lazy = false,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
			on_highlights = function(hl)
				hl.LineNr = { fg = "#ba34d1" }
				hl.LineNrAbove = { fg = "#ba34d1" }
				hl.LineNrBelow = { fg = "#a434eb" }
			end,
		},
	},
}
