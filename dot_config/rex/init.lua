local shell = "com.superlogical.terminal.shell"
local popup_labels = {
	lazygit = "rex-popup-lazygit",
	notes = "rex-popup-notes",
	yazi = "rex-popup-yazi",
	terminal = "rex-popup-terminal",
	translate = "rex-popup-translate",
}

local function popup_exists(view, window_id, label)
	for _, window in ipairs(view.windows or {}) do
		if window.window_id == window_id then
			for _, layer in ipairs(window.layers or {}) do
				if layer.kind == "floating" then
					for _, block in ipairs(layer.blocks or {}) do
						if block.label == label then
							return layer.layer_id
						end
					end
				end
			end
		end
	end
end

local function toggle_popup(ctx, name, command)
	local view, err = rex.session.view({})
	if err then
		error(err, 0)
	end

	local window_id = view.active_window_id
	if ctx.block_id then
		for _, window in ipairs(view.windows or {}) do
			for _, layer in ipairs(window.layers or {}) do
				for _, block in ipairs(layer.blocks or {}) do
					if block.block_id == ctx.block_id then
						window_id = window.window_id
					end
				end
			end
		end
	end

	local label = popup_labels[name]
	local existing_layer = popup_exists(view, window_id, label)
	if existing_layer then
		local _, close_err = rex.session.close_layer({ layer_id = existing_layer })
		if close_err then
			error(close_err, 0)
		end
		return { closed_layer_id = existing_layer }
	end

	local options = {
		login = true,
		command = command,
		theme = {
			background = "#1b0729",
			foreground = "#edecee",
			cursor = "#a277ff",
			scheme = "dark",
		},
	}
	if ctx.block_id then
		local process, process_err = rex.block.call("com.superlogical.terminal", "process", {})
		if process_err then
			error(process_err, 0)
		end
		options.cwd = (process.foreground and process.foreground.cwd) or (process.child and process.child.cwd)
	end

	local layer, layer_err = rex.session.new_layer({
		window_id = window_id,
		bounds = { 0.1, 0.1, 0.8, 0.8 },
		focus = true,
		layout = {
			block = {
				flavor = shell,
				label = label,
				options = options,
			},
		},
	})
	if layer_err then
		error(layer_err, 0)
	end
	return layer
end

rex.action({
	name = "lazygit_popup",
	title = "Toggle LazyGit Popup",
	run = function(ctx)
		return toggle_popup(ctx, "lazygit", { "lazygit" })
	end,
})

rex.action({
	name = "notes_popup",
	title = "Toggle Notes Popup",
	run = function(ctx)
		return toggle_popup(ctx, "notes", { "nvim", "-c", "Obsidian today" })
	end,
})

rex.action({
	name = "yazi_popup",
	title = "Toggle Yazi Popup",
	run = function(ctx)
		return toggle_popup(ctx, "yazi", { "yazi" })
	end,
})

rex.action({
	name = "quick_terminal",
	title = "Toggle Quick Terminal",
	run = function(ctx)
		return toggle_popup(ctx, "terminal")
	end,
})

rex.action({
	name = "translate_popup",
	title = "Toggle Translate Popup",
	run = function(ctx)
		return toggle_popup(ctx, "translate", { "trans-tui", "translate", "--source", "clipboard" })
	end,
})

rex.mode("resize_pane", { exclusive = true })
rex.bind("resize_pane/h", "pane.resize", { direction = "left", amount = 1 })
rex.bind("resize_pane/j", "pane.resize", { direction = "down", amount = 1 })
rex.bind("resize_pane/k", "pane.resize", { direction = "up", amount = 1 })
rex.bind("resize_pane/l", "pane.resize", { direction = "right", amount = 1 })
rex.bind("resize_pane/shift+h", "pane.resize", { direction = "left", amount = 5 })
rex.bind("resize_pane/shift+j", "pane.resize", { direction = "down", amount = 5 })
rex.bind("resize_pane/shift+k", "pane.resize", { direction = "up", amount = 5 })
rex.bind("resize_pane/shift+l", "pane.resize", { direction = "right", amount = 5 })
rex.bind("resize_pane/=", "pane.balance")
rex.bind("resize_pane/enter", "client.mode.exit")

rex.mode("move_tab", { exclusive = true })
rex.bind("move_tab/h", "client.tab.move", { direction = "backward" })
rex.bind("move_tab/j", "client.tab.move", { direction = "backward" })
rex.bind("move_tab/k", "client.tab.move", { direction = "forward" })
rex.bind("move_tab/l", "client.tab.move", { direction = "forward" })
rex.bind("move_tab/enter", "client.mode.exit")

rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+b>b", "client.sidebar.toggle")
rex.bind("ctrl+b>space", "client.palette.toggle")
rex.bind("ctrl+b>-", "pane.split.down")
rex.bind("ctrl+b>shift+\\", "pane.split.right")
rex.bind("ctrl+b>\\", "pane.split.right")
rex.bind("ctrl+b>h", "pane.focus.left")
rex.bind("ctrl+b>j", "pane.focus.down")
rex.bind("ctrl+b>k", "pane.focus.up")
rex.bind("ctrl+b>l", "pane.focus.right")
rex.bind("ctrl+b>q", "pane.close")
rex.bind("ctrl+b>x", "pane.close")
rex.bind("ctrl+b>z", "pane.zoom")
rex.bind("ctrl+b>f", "pane.float")
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>w", "client.palette.toggle")
rex.bind("ctrl+b>r", "client.mode.enter", { name = "resize_pane" })
rex.bind("ctrl+b>m", "client.mode.enter", { name = "move_tab" })
rex.bind("ctrl+b>n", "client.tab.next")
rex.bind("ctrl+b>p", "client.tab.previous")
rex.bind("ctrl+b>g", "lazygit_popup")
rex.bind("ctrl+b>shift+n", "notes_popup")
rex.bind("ctrl+b>y", "yazi_popup")
rex.bind("ctrl+b>t", "quick_terminal")
rex.bind("ctrl+b>shift+t", "translate_popup")
rex.bind("ctrl+b>shift+r", "client.config.reload")
rex.bind("ctrl+b>[", "pane.copy_mode.enter")
