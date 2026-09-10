return {
	{
		"folke/sidekick.nvim",
		opts = {
			cli = {
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
			nes = { enabled = false },
		},
	},
}
