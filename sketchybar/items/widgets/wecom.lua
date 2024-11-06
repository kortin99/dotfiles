local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local wecom = sbar.add("item", "widgets.wecom", {
	position = "right",
	icon = {
		font = {
			style = settings.font.style_map["Regular"],
			size = 19.0,
		},
	},
	label = { font = { family = settings.font.numbers } },
	update_freq = 180,
	popup = { align = "center" },
})
