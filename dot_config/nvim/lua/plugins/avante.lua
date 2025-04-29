return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    opts = {
      -- Default configuration
      hints = { enabled = false },

      provider = "copilot",
      auto_suggest_provider = "copilot",
      copilot = {
        model = "claude-3.5-sonnet",
      },

      -- File selector configuration
      --- @alias FileSelectorProvider "native" | "fzf" | "mini.pick" | "snacks" | "telescope" | string
      file_selector = {
        provider = "snacks",
        provider_opts = {},
      },
    },
    build = LazyVim.is_win() and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or "make",
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      "Kaiser-Yang/blink-cmp-avante",
    },
    opts = {
      sources = {
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
          },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = function(_, filetype)
      return vim.list_extend(filetype, { "Avante" })
    end,
    opts = {
      file_types = {
        "Avante",
      },
    },
  },
}
