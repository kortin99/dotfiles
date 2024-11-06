-- **************************************************
-- 连接到公司 Wi-Fi 时自动静音扬声器
-- **************************************************

-- 定义公司的 Wi-Fi 名称
local WORK_SSIDs = {
	"LY-office",
	"LY-TC",
}

-- 静音函数
local function muteVolume()
	hs.audiodevice.defaultOutputDevice():setOutputMuted(true)
end

-- 取消静音函数
local function unmuteVolume()
	hs.audiodevice.defaultOutputDevice():setOutputMuted(false)
end

-- 检查当前 Wi-Fi 是否在列表中
local function isWorkSSID(ssid)
	for _, workSSID in ipairs(WORK_SSIDs) do
		if ssid == workSSID then
			return true
		end
	end
	return false
end

-- 监听 Wi-Fi 变化
wm_wifiWatcher = hs.wifi.watcher.new(function()
	local currentSSID = hs.wifi.currentNetwork()

	if isWorkSSID(currentSSID) then
		muteVolume() -- 如果是公司 Wi-Fi，则静音
	else
		unmuteVolume() -- 否则取消静音
	end
end)

-- 启动 Wi-Fi 监听
wm_wifiWatcher:start()
