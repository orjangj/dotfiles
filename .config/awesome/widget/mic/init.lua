local beautiful = require("beautiful")
local gears = require("gears")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local function GET_MIC_CMD(device)
  return "amixer -D " .. device .. " sget Capture"
end

local function SET_MIC_CMD(device, value)
  return "amixer -D " .. device .. " sset Capture " .. value .. "%"
end

local function INC_MIC_CMD(device, step)
  return "amixer -D " .. device .. " sset Capture " .. step .. "%+"
end

local function DEC_MIC_CMD(device, step)
  return "amixer -D " .. device .. " sset Capture " .. step .. "%-"
end

local function TOG_MIC_CMD(device)
  return "amixer -D " .. device .. " sset Capture toggle"
end

local mic = {}

local function worker()
  local timeout = 3600
  local base = 80
  local step = 5
  local device = "default"

  mic.widget = wibox.widget({
    {
      {
        id = "text",
        widget = wibox.widget.textbox,
      },
      left = 4,
      right = 4,
      layout = wibox.container.margin,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
  })

  _, mic.watcher = watch(GET_MIC_CMD(device), timeout, function(widget, stdout)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local mic_level = string.match(stdout, "(%d?%d?%d)%%")
    mic_level = tonumber(string.format("% 3d", mic_level))

    local icon, highlight
    if mute == "off" or mic_level == 0 then
      icon = ""
      highlight = beautiful.fg_critical
    else
      icon = ""
      if mic_level > 90 or mic_level < 30 then
        highlight = beautiful.fg_urgent
      else
        highlight = beautiful.fg_normal
      end
    end

    widget:get_children_by_id("text")[1]:set_text(("%s %d%%"):format(icon, mic_level))
    widget:set_fg(highlight)
  end, mic.widget)

  function mic:set(v)
    spawn.easy_async(SET_MIC_CMD(device, v or base), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  function mic:inc(s)
    spawn.easy_async(INC_MIC_CMD(device, s or step), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  function mic:dec(s)
    spawn.easy_async(DEC_MIC_CMD(device, s or step), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  function mic:toggle()
    spawn.easy_async(TOG_MIC_CMD(device), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  return mic.widget
end

return setmetatable(mic, {
  __call = function(_, ...)
    return worker(...)
  end,
})
