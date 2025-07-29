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
    opts = {},
  },
}
