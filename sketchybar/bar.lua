local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	topmost = "window",
	height = 34,
	color = colors.bar.bg,
	padding_right = 2,
	padding_left = 2,
	position = "top",
})
