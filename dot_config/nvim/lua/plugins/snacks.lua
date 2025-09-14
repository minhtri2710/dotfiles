return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        formatters = {
          file = {
            filename_first = true,
            truncate = 80,
          },
        },
        sources = {
          explorer = {
            actions = {
              explorer_del = function(picker)
                local paths = vim.tbl_map(Snacks.picker.util.path, picker:selected({ fallback = true }))
                if #paths == 0 then
                  return
                end
                local what = #paths == 1 and vim.fn.fnamemodify(paths[1], ":p:~:.") or #paths .. " files"
                local Actions = require("snacks.explorer.actions")
                Actions.confirm("Delete " .. what .. "?", function()
                  for _, path in ipairs(paths) do
                    local ok, err = pcall(vim.fn.system, "trash " .. path)
                    if ok then
                      Snacks.bufdelete({ file = path, force = true })
                    else
                      Snacks.notify.error("Failed to delete `" .. path .. "`:\n- " .. err)
                    end
                    local Tree = require("snacks.explorer.tree")
                    Tree:refresh(vim.fs.dirname(path))
                  end
                  picker.list:set_selected()
                  Actions.update(picker)
                end)
              end,
            },
          },
        },
      },
      statuscolumn = { enabled = true },
      styles = {
        snacks_image = {
          relative = "editor",
          col = -1,
        },
        terminal = {
          position = "right",
        },
      },
      image = {
        enabled = true,
        doc = {
          inline = false,
          float = true,
          max_width = 60,
          max_height = 30,
        },
        resolve = function(path, src)
          if require("obsidian.api").path_is_note(path) then
            return require("obsidian.api").resolve_image_path(src)
          end
        end,
      },
      dashboard = {
        formats = {
          key = function(item)
            return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
          end,
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup" },
        },
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
