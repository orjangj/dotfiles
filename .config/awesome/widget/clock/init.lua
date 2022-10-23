local wibox = require("wibox")
local beautiful = require("beautiful")

local calendar = require("widget.calendar")({ theme = beautiful.name, placement = "top_right" })
local clock = {}

local function worker()
  clock = wibox.widget.textclock()

  clock:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      calendar.toggle()
    end
  end)

  return clock
end

return setmetatable(clock, {
  __call = function(_, ...)
    return worker(...)
  end,
})
