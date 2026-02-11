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
			opts.sections.lualine_x = lualine_x

			opts.sections.lualine_y = {
				"progress",
			}
			opts.sections.lualine_z = {
				"location",
			}

			return opts
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
