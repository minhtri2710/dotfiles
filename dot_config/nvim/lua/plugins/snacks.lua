return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        layout = {
          layout = {
            backdrop = true,
          },
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
      },
      statuscolumn = { enabled = true },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
      },
      image = {
        enabled = os.getenv("TMUX") == nil and true or false,
        doc = {
          inline = false,
          float = true,
          max_width = 60,
          max_height = 30,
        },
      },
      dashboard = {
        preset = {
          header = [[
████████╗██████╗ ██╗    ████████╗██████╗  █████╗ ███╗   ██╗
╚══██╔══╝██╔══██╗██║    ╚══██╔══╝██╔══██╗██╔══██╗████╗  ██║
   ██║   ██████╔╝██║       ██║   ██████╔╝███████║██╔██╗ ██║
   ██║   ██╔══██╗██║       ██║   ██╔══██╗██╔══██║██║╚██╗██║
   ██║   ██║  ██║██║       ██║   ██║  ██║██║  ██║██║ ╚████║
   ╚═╝   ╚═╝  ╚═╝╚═╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
]],
        },
      },
    },
    keys = {
      {
        "<leader>fP",
        function()
          Snacks.picker.files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        ";f",
        function()
          Snacks.picker.files({ layout = {
            preview = false,
          } })
        end,
        desc = "Lists files in your current working directory, respects .gitignore",
      },
      {
        ";s",
        function()
          Snacks.picker.smart({ layout = {
            preview = false,
          } })
        end,
        desc = "Lists files in your current working directory, respects .gitignore",
      },
      {
        ";r",
        function()
          Snacks.picker.grep({ hidden = true })
        end,
        desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
      },
      {
        ";;",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume the previous telescope picker",
      },
      {
        "sf",
        function()
          Snacks.picker.explorer({
            cwd = vim.fn.expand("%:p:h"),
            auto_close = true,
            layout = {
              preset = "vertical",
            },
          })
        end,
        desc = "Open File Browser with the path of the current buffer",
      },
      {
        ";u",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo history",
      },
      {
        ";g",
        function()
          Snacks.picker.git_files()
        end,
        desc = "Git files",
      },
      {
        ";gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git branches",
      },
    },
  },
}
