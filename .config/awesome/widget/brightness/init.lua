local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local gears = require("gears")

local brightness = {}

local function SET_BRIGHTNESS_CMD(value)
  return "brightnessctl set " .. value .. "%"
end

local function INC_BRIGHTNESS_CMD(step)
  return "brightnessctl set +" .. step .. "%"
end

local function DEC_BRIGHTNESS_CMD(step)
  return "brightnessctl set " .. step .. "%-"
end

local function worker()
  local timeout = 3600
  local base = 20
  local step = 5

  brightness.widget = wibox.widget({
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

  _, brightness.watcher = watch("bash -c 'brightnessctl max; brightnessctl get'", timeout, function(widget, stdout)
    local max_value, current_level = stdout:match("(%d+)[\r\n]+(%d+)")
    local percentage = 100 * tonumber(current_level) / tonumber(max_value)
    local icon, highlight

    if percentage < 15 then
      icon = ""
      highlight = beautiful.fg_urgent
    elseif percentage > 70 then
      icon = ""
      highlight = beautiful.fg_urgent
    else
      icon = ""
      highlight = beautiful.fg_normal
    end

    widget:get_children_by_id("text")[1]:set_text(string.format("%s %d%%", icon, percentage))
    widget:set_fg(highlight)
  end, brightness.widget)

  function brightness:set(value)
    spawn.easy_async(SET_BRIGHTNESS_CMD(value or base), function()
      brightness.watcher:emit_signal("timeout")
    end)
  end

  function brightness:inc(value)
    spawn.easy_async(INC_BRIGHTNESS_CMD(value or step), function()
      brightness.watcher:emit_signal("timeout")
    end)
  end

  function brightness:dec(value)
    spawn.easy_async(DEC_BRIGHTNESS_CMD(value or step), function()
      brightness.watcher:emit_signal("timeout")
    end)
  end

  return brightness.widget
end

return setmetatable(brightness, {
  __call = function(_, ...)
    return worker(...)
  end,
})
