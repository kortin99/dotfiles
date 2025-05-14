local wezterm = require("wezterm")

local modifier = {
	CTRL = "CTRL",
	SHIFT = "SHIFT",
	CMD = "CMD",
	ALT = "ALT",
	LEADER = "LEADER",
	HYPER = "CMD|SHIFT|ALT|CTRL",
	CMD_SHIFT = "CMD|SHIFT",
	CMD_ALT = "CMD|ALT",
}

local keys = {
	-- Natural Text Editing
	{
		key = "LeftArrow",
		mods = "OPT",
		action = wezterm.action.SendKey({ mods = "ALT", key = "b" }),
	},
	{
		key = "RightArrow",
		mods = "OPT",
		action = wezterm.action.SendKey({ mods = "ALT", key = "f" }),
	},
	{
		key = "LeftArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ mods = "CTRL", key = "a" }),
	},
	{
		key = "RightArrow",
		mods = "CMD",
		action = wezterm.action.SendKey({ mods = "CTRL", key = "e" }),
	},
	{
		key = "Backspace",
		mods = "CMD",
		action = wezterm.action.SendKey({ mods = "CTRL", key = "u" }),
	},

	-- 复制粘贴
	{
		key = "c",
		mods = modifier.CMD,
		action = wezterm.action.CopyTo("Clipboard"),
	},
	{
		key = "v",
		mods = modifier.CMD,
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "Insert",
		mods = modifier.CMD,
		action = wezterm.action.PasteFrom("Clipboard"),
	},

	-- Tab操作
	{
		key = "t",
		mods = modifier.CMD,
		action = wezterm.action.SpawnTab("DefaultDomain"),
	},
	{
		key = "w",
		mods = modifier.CMD_SHIFT,
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "h",
		mods = "CMD|ALT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "l",
		mods = "CMD|ALT",
		action = wezterm.action.ActivateTabRelative(1),
	},
	{
		key = "[",
		mods = modifier.CMD_SHIFT,
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = modifier.CMD_SHIFT,
		action = wezterm.action.ActivateTabRelative(1),
	},

	-- 窗格分屏
	{
		key = "d",
		mods = modifier.CMD,
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "D",
		mods = modifier.CMD_SHIFT,
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "w",
		mods = modifier.CMD,
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
			timemout_miliseconds = 1000,
		}),
	},
}

local key_tables = {
	resize_pane = {
		{ key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },
		{ key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},
}

return {
	disable_default_key_bindings = false,
	disable_default_mouse_bindings = false,
	-- leader = { key = "Space", mods = modifier.CMD_SHIFT },
	leader = { key = "Space", mods = "CTRL|ALT" },
	keys = keys,
	key_tables = key_tables,
}
