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
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      checkbox = {
        enabled = true,
      },
    },
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {},
  },
}
