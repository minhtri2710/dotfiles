return {
  {
    "johannww/tts.nvim",
    cmd = { "TTS" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      voice = "en-US-JennyNeural",
      speed = 1.0,
    },
    keys = {
      {
        ";t",
        "<cmd>TTS<cr>",
        desc = "Text to speech",
        mode = { "v" },
      },
    },
  },
}
