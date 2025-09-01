return {
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
  },
  {
    "brianhuster/live-preview.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
  },
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
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      ui = {
        enable = false,
      },
      open_notes_in = "vsplit",
      note_path_func = function(spec)
        local absolute_dir = "/Users/beowulf/Documents/notes"
        local path = require("obsidian.path")
        local new_path = path.new(absolute_dir) / tostring(spec.id)

        return new_path:with_suffix(".md")
      end,

      workspaces = {
        {
          name = "no-vault",
          path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
          end,
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          enabled = false,
        },
      },
      setup = {
        markdown_oxide = function(_, opts)
          LazyVim.lsp.on_attach(function(client, bufnr)
            local function check_codelens_support()
              if client.server_capabilities.codeLensProvider then
                return true
              end
              return false
            end

            vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
              buffer = bufnr,
              callback = function()
                if check_codelens_support() then
                  vim.lsp.codelens.refresh({ bufnr = bufnr })
                end
              end,
            })
            vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
          end)
        end,
      },
    },
  },
}
