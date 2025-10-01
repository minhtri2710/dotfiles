return {
  -- buffer line
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "tabs",
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    },
  },

  -- status line
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local lualine_x = opts.sections.lualine_x or {}
      table.insert(lualine_x, 1, {
        "searchcount",
      })
      table.insert(lualine_x, {
        function()
          if not vim.g.loaded_mcphub then
            return "󰐻 -"
          end

          local count = vim.g.mcphub_servers_count or 0
          local status = vim.g.mcphub_status or "stopped"
          local executing = vim.g.mcphub_executing

          -- Show "-" when stopped
          if status == "stopped" then
            return "󰐻 -"
          end

          -- Show spinner when executing, starting, or restarting
          if executing or status == "starting" or status == "restarting" then
            local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
            local frame = math.floor(vim.loop.now() / 100) % #frames + 1
            return "󰐻 " .. frames[frame]
          end

          return "󰐻 " .. count
        end,
        color = function()
          if not vim.g.loaded_mcphub then
            return { fg = "#6c7086" } -- Gray for not loaded
          end

          local status = vim.g.mcphub_status or "stopped"
          if status == "ready" or status == "restarted" then
            return { fg = "#50fa7b" } -- Green for connected
          elseif status == "starting" or status == "restarting" then
            return { fg = "#ffb86c" } -- Orange for connecting
          else
            return { fg = "#ff5555" } -- Red for error/stopped
          end
        end,
      })
      opts.sections.lualine_x = lualine_x

      opts.sections.lualine_y = {
        "progress",
      }
      opts.sections.lualine_z = {
        "location",
      }
    end,
  },

  -- filename
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    config = function()
      require("incline").setup({
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end

          local modified = vim.bo[props.buf].modified
          if modified then
            filename = "[+] " .. filename
          end

          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return {
            { icon, guifg = color },
            { " " },
            { filename, gui = modified and "bold,italic" or "bold" },
          }
        end,
      })
    end,
  },
}
