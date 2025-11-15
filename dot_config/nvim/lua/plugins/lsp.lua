return {
  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        phpactor = {
          enabled = false,
        },
        emmet_language_server = {
          filetypes_include = { "phtml" },
        },
        html = {
          filetypes_include = { "phtml" },
        },
      },
    },
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
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            os.getenv("XDG_CONFIG_HOME") .. "/nvim/.markdownlint.json",
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      default_format_opts = {
        timeout_ms = 10000,
      },
      formatters_by_ft = {
        css = {
          "prettier",
          "stylelint",
        },
      },
      formatters = {
        php_cs_fixer = {
          env = {
            PHP_CS_FIXER_IGNORE_ENV = 1,
          },
          prepend_args = function()
            return { "--config=" .. os.getenv("XDG_CONFIG_HOME") .. "/nvim/.php-cs-fixer.php" }
          end,
        },
        kulala = {
          command = { "kulala" },
        },
      },
    },
  },
}
