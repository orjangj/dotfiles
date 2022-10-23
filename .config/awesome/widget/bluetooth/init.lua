local awful = require("awful")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

local bluetooth = {}

local function show_warning(text)
  naughty.notify({
    text = text,
    title = "",
    timeout = 4,
    hover_timeout = 0.5,
    position = "top_right",
    bg = beautiful.red, -- Note: Make the background stand out
    fg = beautiful.fg_normal,
    width = 300,
    screen = mouse.screen,
  })
end

local function worker()
  local timeout = 5
  local status = {
    ["off"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
    ["on"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
  }

  bluetooth = wibox.widget({
    {
      markup = status["off"].symbol .. "0",
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
  })

  -- TODO: popup widget to display detailed info below
  bluetooth.powered = false
  bluetooth.devices = {}

  watch("bluetoothctl show", timeout, function(widget, stdout)
    -- Assuming single controller?
    local powered = string.match(stdout, ".*Powered: (%a+).*")

    if powered == "yes" then
      widget.powered = true
      awful.spawn.easy_async("bluetoothctl info", function(out)
        for s in string.gmatch(out, "Device.*") do
          local macaddr, name, connected = string.match(s, "Device (%w+:%w+:%w+:%w+:%w+:%w+).*Name: ([%w%s]+)[\r\n]+.*Connected: (%a+)")

          if macaddr ~= nil and name ~= nil and connected ~= nil then
            widget.devices[macaddr] = { name = name, connected = connected }
          end
        end

        local count = 0
        for _, _ in pairs(widget.devices) do
          count = count + 1
        end
        widget.widget.markup = string.format("%s %d", status["on"].symbol, count)
        widget.fg = status["on"].fg
        widget.bg = status["on"].bg
      end)
    else
      widget.powered = false
      widget.widget.markup = string.format("%s 0", status["off"].symbol)
      widget.fg = status["off"].fg
      widget.bg = status["off"].bg
      for k, _ in pairs(widget.devices) do
        widget.devices[k] = nil
      end
    end
  end, bluetooth)

  return bluetooth
end

return setmetatable(bluetooth, {
  __call = function(_, ...)
    return worker(...)
  end,
})
