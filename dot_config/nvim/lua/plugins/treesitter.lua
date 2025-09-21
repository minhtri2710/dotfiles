return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "css",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "http",
        "php",
        "rust",
        "scss",
        "sql",
        "markdown",
        "markdown_inline",
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
