return {
  {
    "fei6409/log-highlight.nvim",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "lua",
        "php",
        "markdown",
        "markdown_inline",
        "css",
        "go",
        "rust",
      },
      auto_install = true,
    },
    config = function(_, opts)
      -- MDX
      vim.filetype.add({
        extension = {
          mdx = "mdx",
        },
      })
      vim.treesitter.language.register("markdown", "mdx")
      vim.treesitter.language.register("php", "phtml")
    end,
  },
}
