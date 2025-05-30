-- **************************************************
-- 环形 app 启动器
-- **************************************************
-- 使用方式：
-- 1. 按下 alt + tab 呼出环形菜单，这时候可以松开 tab 键（目前改成了双击 tab 键，第二次按下 tab 键不松开展示，alt + tab 快捷键让给了 AltTab 工具）
-- 2. 滑动鼠标选中目标 app，超出圆的范围也是可以的，鼠标放到中间空白处则是取消选中
-- 3. 松开 alt 键跳到目标 app
-- **************************************************

local tween = {}
function tween.easeOutExpo(t)
	return t == 1 and 1 or 1 - math.pow(2, -10 * t)
end

local utils = {}
function noop() end

function utils.debounce(func, delay)
	local timer = nil

	return function(...)
		local args = { ... }

		if timer then
			timer:stop()
			timer = nil
		end

		timer = hs.timer.doAfter(delay, function()
			func(table.unpack(args))
		end)
	end
end

function utils.throttle(func, delay)
	local wait = false
	local storedArgs = nil
	local timer = nil

	local function checkStoredArgs()
		if storedArgs == nil then
			wait = false
		else
			func(table.unpack(storedArgs))
			storedArgs = nil
			timer = hs.timer.doAfter(delay, checkStoredArgs)
		end
	end

	return function(...)
		local args = { ... }

		if wait then
			storedArgs = args
			return
		end

		func(table.unpack(args))
		wait = true
		timer = hs.timer.doAfter(delay, checkStoredArgs)
	end
end

function utils.clamp(value, min, max)
	return math.max(math.min(value, max), min)
end

--- 用于 Canvas 过渡效果
-- @param options 参数配置
--   @field duration 过渡时长
--   @field easing 缓动函数，函数接受一个真实进度并返回缓动后的进度
--   @field onProgress 过渡时触发
--   @field onEnd 过渡结束后触发
-- @return 用于取消过渡的函数
function utils.animate(options)
	local duration = options.duration
	local easing = options.easing
	local onProgress = options.onProgress
	local onEnd = options.onEnd or noop

	local st = hs.timer.absoluteTime()
	local timer = nil

	local function progress()
		local now = hs.timer.absoluteTime()
		local diffSec = (now - st) / 1000000000

		if diffSec <= duration then
			onProgress(easing(diffSec / duration))
			timer = hs.timer.doAfter(1 / 60, function()
				progress()
			end)
		else
			timer = nil
			onProgress(1)
			onEnd()
		end
	end

	-- 初始执行
	progress()

	return function()
		if timer then
			timer:stop()
			onEnd()
		end
	end
end

-- --------------------------------------------------
-- 自定义配置
-- --------------------------------------------------

-- 菜单项配置
local APPLICATIONS = {
	{ name = "Arc", icon = "/Applications/Arc.app/Contents/Resources/AppIcon.icns" },
	{ name = "WeChat", icon = "/Applications/WeChat.app/Contents/Resources/AppIcon.icns" },
	{ name = "NeteaseMusic", icon = "/Applications/NeteaseMusic.app/Contents/Resources/163Music.icns" },
	-- { name = 'Google Chrome', icon = '/Applications/Google Chrome.app/Contents/Resources/app.icns' },
	-- { name = 'Visual Studio Code', icon = '/Applications/Visual Studio Code.app/Contents/Resources/Code.icns' },
	{ name = "Cursor", icon = "/Applications/Cursor.app/Contents/Resources/Cursor.icns" },
	-- { name = 'WebStorm', icon = '/Applications/WebStorm.app/Contents/Resources/webstorm.icns' },
	{ name = "ApiFox", icon = "/Applications/Apifox.app/Contents/Resources/icon.icns" },
	{ name = "企业微信", icon = "/Applications/企业微信.app/Contents/Resources/AppIcon.icns" },
}
-- 菜单圆环大小
local RING_SIZE = 280
-- 菜单圆环粗细
local RING_THICKNESS = RING_SIZE / 4
-- 图标大小
local ICON_SIZE = RING_THICKNESS / 2
-- 是否菜单在鼠标指针处弹出，而不是居中
local FOLLOW_MOUSE = true
-- 颜色配置
local COLOR_PATTERN = {
	inactive = { hex = "#18181b" },
	active = { hex = "#34a853" },
}
-- 透明度
local ALPHA = 1
-- 是否展示动画
local ANIMATED = true
-- 动画时长
local ANIMATION_DURATION = 0.3

-- --------------------------------------------------
-- 菜单封装
-- --------------------------------------------------

local Menu = {}

-- 创建菜单
function Menu:new(config)
	o = {}
	setmetatable(o, self)
	self.__index = self

	self._menus = config.menus
	self._ringSize = config.ringSize or 360
	self._ringThickness = config.ringThickness or self._ringSize / 3.75
	self._iconSize = config.iconSize or self._ringThickness / 2
	self._canvas = nil
	self._active = nil
	self._inactiveColor = config.inactiveColor or { hex = "#333333" }
	self._activeColor = config.activeColor or { hex = "#3b82f6" }
	self._alpha = config.alpha or 1
	self._animated = config.animated or false
	self._animationDuration = config.animationDuration or 0.5

	local halfRingSize = self._ringSize / 2
	local halfRingThickness = self._ringThickness / 2
	local pieceDeg = 360 / #self._menus
	local halfPieceDeg = pieceDeg / 2
	local halfIconSize = self._iconSize / 2

	self._canvas = hs.canvas.new({
		x = config.left or 0,
		y = config.top or 0,
		w = self._ringSize,
		h = self._ringSize,
	})
	self._canvas:level(hs.canvas.windowLevels.overlay)
	self._canvas:alpha(self._alpha)

	-- 渲染圆环
	local ring = {
		type = "arc",
		action = "stroke",
		center = { x = "50%", y = "50%" },
		radius = halfRingSize - halfRingThickness,
		startAngle = 0,
		endAngle = 360,
		strokeWidth = self._ringThickness,
		strokeColor = self._inactiveColor,
		arcRadii = false,
	}

	self._canvas[1] = ring

	-- 渲染激活项高亮背景
	local indicator = {
		type = "arc",
		action = "stroke",
		center = { x = "50%", y = "50%" },
		radius = halfRingSize - halfRingThickness,
		startAngle = -halfPieceDeg,
		endAngle = halfPieceDeg,
		strokeWidth = self._ringThickness * 0.9,
		strokeColor = self._activeColor,
		arcRadii = false,
	}
	indicator.strokeColor.alpha = 0

	self._canvas[2] = indicator

	-- 渲染 icon
	for key, app in ipairs(self._menus) do
		local image = hs.image.imageFromPath(app.icon)
		local rad = math.rad(pieceDeg * (key - 1) - 90)

		local length = halfRingSize - halfRingThickness
		local x = length * math.cos(rad) + halfRingSize - halfIconSize
		local y = length * math.sin(rad) + halfRingSize - halfIconSize

		self._canvas[key + 2] = {
			type = "image",
			image = image,
			frame = { x = x, y = y, h = self._iconSize, w = self._iconSize },
		}
	end

	return o
end

-- 显示菜单
function Menu:show()
	-- 根据配置决定是否开启动画
	if self._animated then
		local halfRingSize = self._ringSize / 2
		local matrix = hs.canvas.matrix.identity()

		r_cancelAnimation = utils.animate({
			duration = self._animationDuration,
			easing = tween.easeOutExpo,
			onProgress = function(progress)
				self._canvas:transformation(
					matrix
						:translate(halfRingSize, halfRingSize)
						:scale((0.1 * progress) + 0.9)
						:translate(-halfRingSize, -halfRingSize)
				)
				self._canvas:alpha(self._alpha * progress)
			end,
		})
	end

	self._canvas:show()
end

-- 隐藏菜单
function Menu:hide()
	self._canvas:hide()

	if self._animated then
		r_cancelAnimation()
	end
end

-- 返回菜单是否显示
function Menu:isShowing()
	return self._canvas:isShowing()
end

-- 设置菜单激活项
function Menu:setActive(index)
	if self._active ~= index then
		self._active = index

		local pieceDeg = 360 / #self._menus
		local halfPieceDeg = pieceDeg / 2

		if index then
			self._canvas[2].startAngle = pieceDeg * (index - 1) - halfPieceDeg
			self._canvas[2].endAngle = pieceDeg * index - halfPieceDeg
			self._canvas[2].strokeColor.alpha = 1
		else
			self._canvas[2].strokeColor.alpha = 0
		end
	end
end

-- 获取菜单激活项
function Menu:getActive()
	return self._active
end

-- 设置菜单位置（这里指圆点 x、y 坐标）
function Menu:setPosition(topLeft)
	self._canvas:topLeft({ x = topLeft.x - self._ringSize / 2, y = topLeft.y - self._ringSize / 2 })
end

-- --------------------------------------------------
-- 菜单调用以及事件监听处理
-- --------------------------------------------------

-- 保存菜单弹出时鼠标的位置
local menuPos = nil

local menu = Menu:new({
	menus = APPLICATIONS,
	ringSize = RING_SIZE,
	ringThickness = RING_THICKNESS,
	iconSize = ICON_SIZE,
	inactiveColor = COLOR_PATTERN.inactive,
	activeColor = COLOR_PATTERN.active,
	alpha = ALPHA,
	animated = ANIMATED,
	animationDuration = ANIMATION_DURATION,
})

-- 处理鼠标移动事件
local function handleMouseMoved()
	local mousePos = hs.mouse.absolutePosition()

	-- 鼠标指针与中心点的距离
	local distance = math.sqrt(math.abs(mousePos.x - menuPos.x) ^ 2 + math.abs(mousePos.y - menuPos.y) ^ 2)
	local rad = math.atan2(mousePos.y - menuPos.y, mousePos.x - menuPos.x)
	local deg = math.deg(rad)
	-- 转为 0 - 360
	deg = (deg + 90 + 360 / #APPLICATIONS / 2) % 360

	local active = math.ceil(deg / (360 / #APPLICATIONS))
	-- 在中心空洞中不激活菜单
	if distance <= RING_SIZE / 2 - RING_THICKNESS then
		active = nil
	end

	menu:setActive(active)
end
-- 貌似也并没节省到性能，throttle 一下图心理安慰
local throttledHandleMouseMoved = utils.throttle(handleMouseMoved, 1 / 60)

-- 显示逻辑处理
local function handleShowMenu()
	if menu:isShowing() then
		return
	end

	local frame = hs.mouse.getCurrentScreen():fullFrame()

	if FOLLOW_MOUSE then
		local mousePos = hs.mouse.absolutePosition()
		menuPos = {
			x = utils.clamp(mousePos.x, frame.x + RING_SIZE / 2, frame.x + frame.w - RING_SIZE / 2),
			y = utils.clamp(mousePos.y, frame.y + RING_SIZE / 2, frame.y + frame.h - RING_SIZE / 2),
		}
	else
		menuPos = {
			x = (frame.x + frame.w) / 2,
			y = (frame.y + frame.h) / 2,
		}
	end

	menu:setPosition(menuPos)
	menu:show()

	-- 菜单显示后开始监听鼠标移动事件
	r_mouseEvtTap = hs.eventtap.new({ hs.eventtap.event.types.mouseMoved }, throttledHandleMouseMoved)
	r_mouseEvtTap:start()

	-- 初始化触发计算一次
	handleMouseMoved()
end

-- 隐藏逻辑处理
local function handleHideMenu()
	if not menu:isShowing() then
		return
	end

	menu:hide()
	-- 菜单隐藏后移除监听鼠标移动事件
	r_mouseEvtTap:stop()

	local active = menu:getActive()

	if active then
		local onActive = APPLICATIONS[active].onActive
		-- 如果菜单项中配置了 onActive，则执行自定义行为，否则作为程序打开
		if onActive then
			onActive()
		else
			hs.application.launchOrFocus(APPLICATIONS[menu:getActive()].name)
		end
	end
end

function isOnlyAltDown(event)
	local modifiers = event:getFlags()
	local keyCode = event:getKeyCode()

	-- 如果 alt 键没有被按下，直接返回 false
	if not modifiers.alt then
		return false
	end

	-- 检查可能的其他修饰键
	-- 如果有任何其他修饰键被按下，flags 表中会有额外的键
	local count = 0
	for _ in pairs(modifiers) do
		print(_)
		count = count + 1
	end

	print("count", count)
	print("keyCode", keyCode)

	-- 如果只有 alt 键被按下，flags 表中应该只有一个键
	return count == 1 and keyCode == 58
end

local isAltPressed = false
local timer = hs.timer.new(0.15, function()
	isAltPressed = false
end)
-- 处理按键事件
local function handleKeyEvent(event)
	-- local isAltDown = event:getFlags().alt
	--  判断只有 alt 键按下，而不是 alt + 其他快捷键
	-- local keyFlags = event:getFlags()
	-- 检查是否只有 alt 键被按下，而不是 alt + 其他快捷键
	local isAltDown = isOnlyAltDown(event)
	print("isAltDown", isAltDown)

	timer:stop()

	if not isAltDown then
		handleHideMenu()
		return false
	end

	-- 如果是第一次按下 alt 键，则记录状态
	if isAltPressed == false and isAltDown == true then
		isAltPressed = true

		print("记录了isAltPressed", isAltPressed)
		-- 定时器，如果 0.15 秒内没有再次按下 alt 键，则认为是一次性按下，否则认为是双击
		timer:start()

		return false
	end

	-- 如果是第二次按下 alt 键，则显示菜单
	if isAltPressed == true and isAltDown == true then
		isAltPressed = false
		handleShowMenu()
		return true
	end

	-- 48 为 tab，58 为 alt
	-- local keyCode = event:getKeyCode()

	-- -- 按下了 alt + tab 后显示菜单
	-- if keyCode == 48 and isAltDown then
	-- 	handleShowMenu()
	-- 	-- 阻止事件传递，否则会导致焦点切换，因为按下了 tab 键
	-- 	return true
	-- end

	-- -- 松开了 alt 后隐藏菜单
	-- if keyCode == 58 and not isAltDown then
	-- 	handleHideMenu()
	-- end

	return false
end

-- 监听快捷键
r_keyEvtTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.flagsChanged }, handleKeyEvent)
r_keyEvtTap:start()
