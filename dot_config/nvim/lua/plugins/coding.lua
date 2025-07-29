return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufEnter",
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    lazy = true,
    dependencies = { "fang2hou/blink-copilot" },
    opts = {
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
          copilot = {
            module = "blink-copilot",
          },
        },
      },
    },
  },
}
