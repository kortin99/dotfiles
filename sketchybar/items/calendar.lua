local settings = require("settings")
local colors = require("colors")

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local cal = sbar.add("item", {
	icon = {
		color = colors.white,
		padding_left = 8,
		font = {
			style = settings.font.style_map["Black"],
			size = 12.0,
		},
	},
	label = {
		color = colors.white,
		padding_right = 8,
		width = 90,
		align = "right",
		font = { family = settings.font.numbers },
	},
	position = "right",
	update_freq = 30,
	padding_left = 1,
	padding_right = 1,
	background = {
		color = colors.bg2,
		border_color = colors.black,
		border_width = 1,
	},
})

-- Double border for calendar using a single item bracket
sbar.add("bracket", { cal.name }, {
	background = {
		color = colors.transparent,
		height = 30,
		border_color = colors.grey,
	},
})

-- Padding item required because of bracket
sbar.add("item", { position = "right", width = settings.group_paddings })

local getChineseWeekday = function()
	local weekdays = { "日", "一", "二", "三", "四", "五", "六" }
	local weekNum = os.date("*t").wday
	return "周" .. weekdays[weekNum]
end

cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
	cal:set({ icon = os.date("%m月%d日 "), label = os.date("%H:%M") .. " " .. getChineseWeekday() })
end)

cal:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a 'Calendar'")
end)
