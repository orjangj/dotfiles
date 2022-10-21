
local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")

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
  local base = 20
  local step = 5
  local level = { -- Is this really necessary? :D
    ["low"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["medium"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["high"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
  }

  local textbox = wibox.widget({
    markup = level["high"].symbol .. string.format("%s%%", base),
    font = beautiful.font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  brightness.widget = wibox.widget({
    textbox,
    fg = level["medium"].fg,
    bg = level["medium"].bg,
    widget = wibox.container.background,
  })

  spawn.easy_async("brightnessctl max", function(stdout)
    brightness.max_value = tonumber(string.format("%.0f", stdout))
  end)

  -- TODO: Why is it only updated on one screen with multi-monitor setup?
  local function update()
    spawn.easy_async(GET_BRIGHTNESS_CMD(), function(out)
      local percentage = 100 * tonumber(string.format("%.0f", out)) / brightness.max_value
      local type
      if percentage < 10 then
        type = level.low
      elseif percentage > 70 then
        type = level.high
      else
        type = level.medium
      end
      brightness.widget.widget.markup = type.symbol .. " " .. ("%d"):format(percentage) .. "%"
      brightness.widget.fg = type.fg
      brightness.widget.bg = type.bg
    end)
  end

  brightness.widget:connect_signal("redraw_needed", update)

  function brightness:set(value)
    spawn.easy_async(SET_BRIGHTNESS_CMD(value or base), function()
      brightness.widget:emit_signal("redraw_needed")
    end)
  end

  function brightness:inc(value)
    spawn.easy_async(INC_BRIGHTNESS_CMD(value or step), function()
      brightness.widget:emit_signal("redraw_needed")
    end)
  end

  function brightness:dec(value)
    spawn.easy_async(DEC_BRIGHTNESS_CMD(value or step), function()
      brightness.widget:emit_signal("redraw_needed")
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
