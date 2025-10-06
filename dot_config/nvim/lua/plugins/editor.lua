return {
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      user_default_options = {
        AARRGGBB = true,
        css = true,
        xterm = true,
        tailwind = true,
        sass = { enable = true, parsers = { css = true } },
      },
    },
  },
}
