return {
  {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
      {
        "<leader>aa",
        false,
      },
      {
        "<leader>as",
        function()
          require("sidekick.cli").toggle({ focus = true })
        end,
        desc = "Sidekick Toggle",
        mode = { "n" },
      },
    },
  },
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ["<Tab>"] = {
          "snippet_forward",
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          function()
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
      },
    },
  },
}
