return {
  {
    "m4xshen/hardtime.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufEnter",
  },
  {
    "giuxtaposition/blink-cmp-copilot",
j   enabled = false,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      "fang2hou/blink-copilot",
      opts = {
        max_completions = 1,
        max_attempts = 2,
      },
    },
    opts = {
      fuzzy = {
        implementation = "prefer_rust_with_warning",
      },
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3,
            },
          },
        },
      },
    },
  },
}
