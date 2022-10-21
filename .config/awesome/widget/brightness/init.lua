local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local gears = require("gears")

local brightness = {}

local function SET_BRIGHTNESS_CMD(value)
  return "brightnessctl set " .. value .. "%"
end

local function GET_BRIGHTNESS_CMD()
  return "brightnessctl get"
end

local function INC_BRIGHTNESS_CMD(step)
  return "brightnessctl set +" .. step .. "%"
end

local function DEC_BRIGHTNESS_CMD(step)
  return "brightnessctl set " .. step .. "%-"
end

local function worker()
  spawn.easy_async("brightnessctl max", function(stdout)
    brightness.max_value = tonumber(string.format("%.0f", stdout))
  end)

  local timeout = 3600
  local base = 20
  local step = 5
  local level = { -- Is this really necessary? :D
    ["low"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["medium"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["high"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
  }

  brightness.widget = wibox.widget({
    {
      markup = level["high"].symbol,
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = level["medium"].fg,
    bg = level["medium"].bg,
    widget = wibox.container.background,
  })

  _, brightness.watcher = watch(GET_BRIGHTNESS_CMD(), timeout, function(widget, stdout)
    local percentage = 100 * tonumber(string.format("%.0f", stdout)) / brightness.max_value
    local type

    if percentage < 10 then
      type = level.low
    elseif percentage > 70 then
      type = level.high
    else
      type = level.medium
    end

    widget.widget.markup = ("%s %d%%"):format(type.symbol, percentage)
    widget.fg = type.fg
    widget.bg = type.bg
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

  -- set the brightness_level before leaving
  brightness:set(base)

  return brightness.widget
end

return setmetatable(brightness, {
  __call = function(_, ...)
    return worker(...)
  end,
})
