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
      completion = {
        menu = {
          winblend = vim.o.pumblend,
        },
        documentation = {
          window = {
            winblend = vim.o.pumblend,
          },
        },
      },
      signature = {
        window = {
          winblend = vim.o.pumblend,
        },
      },
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      sources = {
        providers = {
          copilot = {
            module = "blink-copilot",
          },
        },
      },
    },
  },
}
