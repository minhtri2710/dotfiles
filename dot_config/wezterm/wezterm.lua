local wezterm = require("wezterm")
local act = wezterm.action

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Aura (Gogh)"
config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"FiraCode Nerd Font",
})
config.font_size = 15.5
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.window_background_gradient = {
	orientation = "Vertical",
	colors = {
		"#1b0729",
		"#31043d",
	},
}
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.default_workspace = "main"
config.enable_kitty_keyboard = true
config.allow_win32_input_mode = false

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.colors = {
	tab_bar = {
		background = "#15141e",
		new_tab = {
			bg_color = "#15141e",
			fg_color = "#505050",
		},
	},
}
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#15141e"
	local edge_background = "#15141e"
	local foreground = "#edecee"

	if tab.is_active then
		background = "#a277ff"
		foreground = "#82e2ff"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

-- Padding
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Dim inactive panes
config.inactive_pane_hsb = {
	saturation = 0.24,
	brightness = 0.5,
}

-- Keys
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	-- Send C-b when pressing C-b twice
	{ key = "b", mods = "LEADER|CTRL", action = act.SendKey({ key = "b", mods = "CTRL" }) },
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "phys:Space", mods = "LEADER", action = act.ActivateCommandPalette },

	-- Pane keybindings
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
	{ key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "o", mods = "LEADER", action = act.RotatePanes("Clockwise") },

	-- Tab keybindings
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
	{
		key = "r",
		action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
		mods = "LEADER",
	},
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tab", one_shot = false }) },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
}

config.key_tables = {
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
	move_tab = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "j", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "l", action = act.MoveTabRelative(1) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
	},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "nu" }
	config.font_size = 12
	table.insert(config.keys, { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") })
	table.insert(config.keys, { key = "v", mods = "CTRL", action = act.PasteFrom("PrimarySelection") })
end

return config
