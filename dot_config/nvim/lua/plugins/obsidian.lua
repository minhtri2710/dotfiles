return {
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
      workspaces = {
        {
          name = "Obsidian",
          path = function()
            if (vim.fn.has("win32")) == 1 then
              return "C:/Users/tri.tran/Downloads/Obsidian/Beowulf"
            end

            return "~/Documents/obsidian/Second Brain/"
          end,
        },
      },
    },
  },
}
