return {
  {
    "sudo-tee/opencode.nvim",
    lazy = false,
    opts = {},
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "opencode_output" },
      },
      "folke/snacks.nvim",
    },
  },
}
