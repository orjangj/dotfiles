local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local bluetooth = {}

local function worker()
  local timeout = 10

  bluetooth = wibox.widget({
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

  -- TODO: popup widget to display detailed info below
  local devices = {}

  watch("bluetoothctl show", timeout, function(widget, stdout)
    -- TODO: Assuming single controller?
    local icon = ""
    local is_powered = string.match(stdout, ".*Powered: (%a+).*")

    if is_powered == "yes" then
      awful.spawn.easy_async("bluetoothctl info", function(out)
        for s in string.gmatch(out, "Device.*") do
          local macaddr, name, connected =
            string.match(s, "Device (%w+:%w+:%w+:%w+:%w+:%w+).*Name: ([%w%s]+)[\r\n]+.*Connected: (%a+)")

          if macaddr ~= nil and name ~= nil and connected ~= nil then
            devices[macaddr] = { name = name, connected = connected }
          end
        end

        local count = 0
        for _, _ in pairs(devices) do
          count = count + 1
        end

        widget:get_children_by_id("text")[1]:set_text(string.format("%s %d", icon, count))
        widget:set_fg(beautiful.fg_normal)
      end)
    else
      for k, _ in pairs(devices) do
        devices[k] = nil
      end
      widget:get_children_by_id("text")[1]:set_text(string.format("%s 0", icon))
      widget:set_fg(beautiful.fg_critical)
    end
  end, bluetooth)

  return bluetooth
end

return setmetatable(bluetooth, {
  __call = function(_, ...)
    return worker(...)
  end,
})
