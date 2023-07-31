local beautiful = require("beautiful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local temperature = {}

local function worker()
  local timeout = 15

  temperature = wibox.widget({
    id = "text",
    widget = wibox.widget.textbox,
  })

  watch("bash -c 'sensors'", timeout, function(widget, stdout)
    local cpu_temp = string.match(stdout, "Package id %d+:%s+[%+-](%d+)")
    cpu_temp = tonumber(cpu_temp)

    local icon, highlight
    if cpu_temp < 50 then
      icon = ""
      highlight = beautiful.fg_normal
    elseif cpu_temp < 70 then
      icon = ""
      highlight = beautiful.fg_focus
    elseif cpu_temp < 90 then
      icon = ""
      highlight = beautiful.fg_urgent
    else
      icon = ""
      highlight = beautiful.fg_critical
    end

    widget
      :get_children_by_id("text")[1]
      :set_markup_silently(("<span foreground='%s'>%s %d°C</span>"):format(highlight, icon, cpu_temp))
  end, temperature)

  return temperature
end

return setmetatable(temperature, {
  __call = function(_, ...)
    return worker(...)
  end,
})
