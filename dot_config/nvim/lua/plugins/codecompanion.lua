-- Helper function to merge options
local function merge_opts(defaults, opts)
  opts = opts or {}
  if vim.tbl_deep_extend then
    return vim.tbl_deep_extend("force", defaults, opts)
  else
    -- Fallback for older Neovim versions
    return vim.tbl_extend("force", defaults, opts)
  end
end

-- Reusable keymaps for CodeCompanion
local codecompanion_keymaps = {
  close = { modes = { n = "q" } },
  stop = { modes = { n = "<Esc>" } },
  send = { modes = { n = "<CR>" } },
}

-- Reusable roles for CodeCompanion
local codecompanion_roles = {
  llm = " CodeCompanion",
  user = " " .. (vim.env.USER or "Beowulf"),
}

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
            roles = codecompanion_roles,
            keymaps = codecompanion_keymaps,
            adapter = {
              name = "copilot",
              model = "gpt-5-mini",
            },
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_tools = true,
              show_server_tools_in_chat = true,
              add_mcp_prefix_to_tool_names = false,
              show_result_in_chat = true,
              make_vars = true,
              make_slash_commands = true,
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
            vim.cmd("CodeCompanion " .. input)
          else
            vim.notify("No input provided.", vim.log.levels.WARN)
          end
        end,
        desc = "Inline prompt (CodeCompanion)",
        mode = { "n", "v" },
      },
    },
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
