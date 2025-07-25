local wezterm = require("wezterm")
local merge = require("utils.table").merge

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

local bg_color = "#141414"
local tab_bar_color = "#171d21"

local config = {

	-- font
	font_size = 14,
	line_height = 1.35,
	font = wezterm.font_with_fallback({
		{
			family = "DroidSansM Nerd Font Mono",
			weight = "Bold",
		},
		{
			family = "JetBrainsMono Nerd Font Mono",
			weight = "Bold",
		},
		{
			family = "Hack Nerd Font",
			weight = "Bold",
		},
	}),
	adjust_window_size_when_changing_font_size = false,

	-- theme
	color_scheme = "Catppuccin Mocha",
	window_background_opacity = 1,
	macos_window_background_blur = 99,
	text_background_opacity = 1,

	-- cursor
	default_cursor_style = "BlinkingBlock",
	cursor_blink_rate = 700,

	-- window
	window_decorations = "RESIZE",
	window_padding = {
		left = 24,
		right = 24,
		top = 24,
		bottom = 5,
	},
	window_frame = {
		font_size = 15.0,
		active_titlebar_bg = "#151d22",
		inactive_titlebar_bg = "#111",
	},
	animation_fps = 60,
	max_fps = 60,
	front_end = "WebGpu",
	webgpu_power_preference = "HighPerformance",

	-- tab bar
	use_fancy_tab_bar = true,
	tab_bar_at_bottom = true,
	hide_tab_bar_if_only_one_tab = true,
	show_new_tab_button_in_tab_bar = false,
	-- show_close_tab_button_in_tabs = false, -- not support yet
	tab_and_split_indices_are_zero_based = false,

	colors = {
		background = bg_color,

		tab_bar = {
			background = bg_color,

			active_tab = {
				-- bg_color = "#222a2f",
				bg_color = bg_color,
				fg_color = "#c0c0c0",
				intensity = "Bold",
				underline = "None",
				italic = false,
				strikethrough = false,
			},

			inactive_tab = {
				bg_color = tab_bar_color,
				fg_color = "#808080",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},

			inactive_tab_hover = {
				bg_color = "#2f373b",
				fg_color = "#909090",
				italic = true,
			},

			inactive_tab_edge = tab_bar_color,

			new_tab = {
				bg_color = "#1b1032",
				fg_color = "#808080",
			},

			new_tab_hover = {
				bg_color = "#3b3052",
				fg_color = "#909090",
				italic = true,
			},
		},
	},

	window_background_gradient = {
		orientation = "Vertical",
		colors = {
			bg_color,
			"#14222A",
			tab_bar_color,
		},
		interpolation = "Linear",
		blend = "Rgb",
	},
}

-- 超链接规则配置
config.hyperlink_rules = wezterm.default_hyperlink_rules()
table.insert(config.hyperlink_rules, {
	regex = 'http://localhost:3000',
	format = "$1",
})

-- ssh
config.ssh_domains = {
	{
		name = "RackNerd",
		remote_address = "23.94.56.114",
		username = "root",
		connect_automatically = false,
		multiplexing = "None",
		local_echo_threshold_ms = 10,
		-- ssh_option = {
		-- identity_file = '/Users/kortin/.ssh/id_rsa',
		-- },
	},
}

-- Notification when the configuration is reloaded
local function toast(window, message)
	window:toast_notification("wezterm", message .. " - " .. os.date("%I:%M:%S %p"), nil, 1000)
end

wezterm.on("window-config-reloaded", function(window, pane)
	toast(window, "Configuration reloaded!")
end)

return merge(config, require("keys"), require("mouse"))
