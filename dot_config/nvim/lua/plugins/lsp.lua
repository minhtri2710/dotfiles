return {
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      vim.list_extend(keys, {
        {
          "gd",
          function()
            -- DO NOT RESUSE WINDOW
            require("telescope.builtin").lsp_definitions({ reuse_win = false })
          end,
          desc = "Goto Definition",
          has = "definition",
        },
      })

      return vim.tbl_deep_extend("force", opts, {
        inlay_hints = { enabled = false },
        ---@type lspconfig.options
        servers = {
          phpactor = {
            enabled = true,
          },
          intelephense = {
            enabled = true,
          },
        },
        setup = {},
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        phpcs = {
          args = {
            "-q",
            "--standard=PSR12",
            "--exclude=Generic.WhiteSpace.DisallowTabIndent,Squiz.Functions.MultiLineFunctionDeclaration,PSR2.Classes.ClassDeclaration",
            "--report=json",
            "-",
          },
        },
      },
    },
  },

  {
    {
      "stevearc/conform.nvim",
      optional = true,
      opts = {
        default_format_opts = {
          timeout_ms = 10000,
          stop_after_first = true,
        },
        formatters_by_ft = {
          javascript = { "dprint", "prettierd", "prettier" },
          javascriptreact = { "dprint", "prettierd", "prettier" },
          typescript = { "dprint", "prettierd", "prettier" },
          typescriptreact = { "dprint", "prettierd", "prettier" },
          css = { "dprint", "prettierd", "prettier", "stylelint" },
          php = { "pretty-php", "php_cs_fixer" },
        },
        formatters = {
          dprint = {
            condition = function(_, ctx)
              return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
            end,
          },
          ["pretty-php"] = {
            prepend_args = {
              "--psr12",
            },
          },
          php_cs_fixer = {
            env = {
              PHP_CS_FIXER_IGNORE_ENV = 1,
            },
            prepend_args = function()
              if vim.fn.has("win32") == 1 then
                return { "--config=C:/Users/tri.tran/AppData/Local/nvim/.php-cs-fixer.php" }
              end

              return { "--config=/Users/beowulf/.config/nvim/.php-cs-fixer.php" }
            end,
          },
        },
      },
    },
  },
}
