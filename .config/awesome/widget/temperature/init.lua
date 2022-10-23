local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local temperature = {}

local function worker()
  local timeout = 15

  local level = {
    ["low"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["medium"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["high"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["critical"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
  }

  temperature = wibox.widget({
    {
      markup = level["medium"].symbol,
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = level["medium"].fg,
    bg = level["medium"].bg,
    widget = wibox.container.background,
  })

  local function show_warning(text)
    naughty.notify({
      text = text,
      title = "",
      timeout = timeout,
      hover_timeout = 0.5,
      position = "top_right",
      bg = beautiful.red, -- Note: Make the background stand out
      fg = beautiful.fg_normal,
      width = 300,
      screen = mouse.screen,
    })
  end

  watch("bash -c 'sensors'", timeout, function(widget, stdout)
    local cpu_temp = string.match(stdout, "Package id %d+:%s+[%+-](%d+)")
    cpu_temp = tonumber(cpu_temp)

    local type
    if cpu_temp <= 15 then
      type = level["low"]
    elseif cpu_temp <= 45 then
      type = level["medium"]
    elseif cpu_temp <= 80 then
      type = level["high"]
    else
      type = level["critical"]
    end

    widget.widget.markup = string.format("%s %d°C", type.symbol, cpu_temp)
    widget.fg = type.fg
    widget.bg = type.bg
  end, temperature)

  return temperature
end

return setmetatable(temperature, {
  __call = function(_, ...)
    return worker(...)
  end,
})
