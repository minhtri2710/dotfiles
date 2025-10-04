return {
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {
        mux = {
          backend = "tmux",
          enabled = true,
        },
      },
    },
    keys = function()
      return {
        {
          "<tab>",
          function()
            -- if there is a next edit, jump to it, otherwise apply it if any
            if require("sidekick").nes_jump_or_apply() then
              return -- jumped or applied
            end
            -- if you are using Neovim's native inline completions
            if vim.lsp.inline_completion.get() then
              return
            end
            -- fall back to normal tab
            return "<tab>"
          end,
          mode = { "i", "n" },
          expr = true,
          desc = "Goto/Apply Next Edit Suggestion",
        },
        {
          "<leader>as",
          nil,
          desc = "+Sidekick",
          mode = { "n", "v" },
        },
        {
          "<leader>asa",
          function()
            require("sidekick.cli").toggle({ filter = { installed = true }, focus = true })
          end,
          desc = "Sidekick Toggle",
          mode = { "n" },
        },
        {
          "<leader>ass",
          function()
            require("sidekick.cli").select({ filter = { installed = true } })
          end,
          desc = "Select CLI",
        },
        {
          "<leader>ast",
          function()
            require("sidekick.cli").send({ msg = "{this}" })
          end,
          mode = { "x", "n" },
          desc = "Send This",
        },
        {
          "<leader>asv",
          function()
            require("sidekick.cli").send({ msg = "{selection}" })
          end,
          mode = { "x" },
          desc = "Send Visual Selection",
        },
        {
          "<leader>asp",
          function()
            require("sidekick.cli").prompt()
          end,
          mode = { "n", "x" },
          desc = "Sidekick Select Prompt",
        },
        {
          "<c-.>",
          function()
            require("sidekick.cli").focus()
          end,
          mode = { "n", "x", "i", "t" },
          desc = "Sidekick Switch Focus",
        },
        {
          "<leader>aso",
          function()
            require("sidekick.cli").toggle({ name = "opencode", focus = true })
          end,
          desc = "Sidekick Opencode Toggle",
        },
      }
    end,
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
