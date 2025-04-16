local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the shell script that provides the event "mem_update"
-- Run it once immediately
sbar.exec("killall memory_load.sh >/dev/null 2>&1 || true")
sbar.exec("$CONFIG_DIR/helpers/event_providers/mem_load/memory_load.sh")

-- 创建内存监控图形
local memory = sbar.add("graph", "widgets.memory", 42, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.ram },
  label = {
    string = "mem ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 9.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4
  },
  padding_right = settings.paddings + 6,
  update_freq = 2  -- 每2秒更新一次
})

-- 使用内存图形组件自身的routine事件来触发内存状态检查
memory:subscribe("routine", function(_)
  sbar.exec("$CONFIG_DIR/helpers/event_providers/mem_load/memory_load.sh")
end)

memory:subscribe("mem_update", function(env)
  -- Memory usage percentage from mem_load
  local load = tonumber(env.used_perc)
  memory:push({ load / 100. })

  local totalGB = tonumber(env.total_gb) or 0
  local usedGB = tonumber(env.used_gb) or 0
  -- print(string.format("总内存: %.2f GB, 已用: %.2f GB", totalGB, usedGB))

  local color = colors.blue
  if load > 65 then -- Thresholds for memory
    if load < 80 then
      color = colors.yellow
    elseif load < 90 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  memory:set({
    graph = { color = color },
    label = string.format("mem %d%%", load),
  })
end)

memory:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the memory item
sbar.add("bracket", "widgets.memory.bracket", { memory.name }, {
  background = { color = colors.bg1 }
})

-- Background around the memory item
sbar.add("item", "widgets.memory.padding", {
  position = "right",
  width = settings.group_paddings
})
