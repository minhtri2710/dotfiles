return {
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
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    opts = {},
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
  },
  {
    "diegoulloao/neofusion.nvim",
    lazy = false,
  },
}
