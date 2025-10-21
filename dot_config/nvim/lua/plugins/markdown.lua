return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    opts = {
      completions = {
        lsp = {
          enabled = true,
        },
        blink = {
          enabled = true,
        },
      },
      code = {
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
    config = function(_, opts)
      -- call the plugin setup with the opts
      local ok, rm = pcall(require, "render-markdown")
      if ok and type(rm.setup) == "function" then
        rm.setup(opts)
      end

      -- ensure tree-sitter highlighter is started for markdown buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
          local bufnr = args.buf
          local okp, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
          if okp and parser then
            pcall(vim.treesitter.start, bufnr, "markdown")
          end
        end,
      })
    end,
  },
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    keys = {
      {
        "<M-l><M-o>",
        mode = { "n", "i" },
        "<Cmd>MDListItemBelow<CR>",
        desc = "Add list item below",
      },
      {
        "<M-L><M-O>",
        mode = { "n", "i" },
        "<Cmd>MDListItemAbove<CR>",
        desc = "Add list item above",
      },
      {
        "<M-c>",
        mode = { "n", "x" },
        "<Cmd>MDTaskToggle<CR>",
        desc = "Toggle task checkbox",
      },
    },
    opts = {},
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
  {
    "obsidian-nvim/obsidian.nvim",
    lazy = false,
    keys = {
      {
        "<leader>N",
        ":vsplit | ObsidianToday<Return>",
        desc = "Open today's note in Obsidian",
        mode = "n",
      },
    },
    opts = {
      completion = {
        nvim_cmp = false,
        blink = true,
      },
      workspaces = {
        {
          name = "SecondBrain",
          path = "~/second-brain",
          overrides = {
            notes_subdir = "notes",
          },
        },
      },
      daily_notes = {
        folder = "notes/dailies",
      },
      checkbox = {
        order = { " ", "x" },
      },
      ui = {
        enable = false,
      },
    },
  },
}
