-- Helper function to merge options
local function merge_opts(defaults, opts)
  return vim.tbl_deep_extend("force", defaults, opts or {})
end

-- Reusable keymaps for CodeCompanion
local codecompanion_keymaps = {
  close = { modes = { n = "q" } },
  stop = { modes = { n = "<Esc>" } },
  send = { modes = { n = "<CR>" } },
}

-- Reusable roles for CodeCompanion
local function get_codecompanion_roles()
  local user = vim.env.USER or "Beowulf"
  return {
    llm = "  CodeCompanion",
    user = "  " .. user,
  }
end

return {
  -- CodeCompanion plugin configuration
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
    },
    opts = function(_, opts)
      return merge_opts(opts, {
        strategies = {
          chat = {
            roles = get_codecompanion_roles(),
            keymaps = codecompanion_keymaps,
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
              make_vars = true, -- make chat #variables from MCP server resources
              make_slash_commands = true, -- make /slash_commands from MCP server prompts
            },
          },
        },
        adapters = {
          gemma3 = function()
            return require("codecompanion.adapters").extend("ollama", {
              name = "gemma3", -- Give this adapter a different name to differentiate it from the default ollama adapter
              schema = {
                model = {
                  default = "gemma3:1b",
                },
                num_ctx = {
                  default = 16384,
                },
                num_predict = {
                  default = -1,
                },
              },
            })
          end,
        },
      })
    end,
    keys = {
      {
        "<leader>a",
        nil,
        desc = "+ai",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        "<cmd>CodeCompanionActions<cr>",
        desc = "Prompt Actions (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<cr>",
        desc = "Toggle (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>ai",
        function()
          local input = vim.fn.input("Enter your prompt: ")
          if input and input ~= "" then
            vim.cmd(string.format("CodeCompanion %s", input))
          else
            print("No input provided.")
          end
        end,
        desc = "Inline prompt (CodeCompanion)",
        mode = { "n", "v" },
      },
    },
  },

  -- Edgy.nvim plugin configuration
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "codecompanion",
        title = "CodeCompanion Chat",
        size = { width = 60 },
      })
    end,
  },

  -- Blink.cmp plugin configuration
  {
    "saghen/blink.cmp",
    lazy = true,
    opts = {
      sources = {
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
