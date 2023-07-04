local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local wifi = {}

local function worker()
  local timeout = 5

  wifi = wibox.widget({
    {
      {
        id = "text",
        widget = wibox.widget.textbox,
      },
      layout = wibox.container.margin,
    },
    bg = beautiful.bg_critical,
    widget = wibox.container.background,
  })

  -- TODO: Time since last connected verified: to keep track of whether we are still connected?
  -- TODO: On what conditions to set critical, bad, good and excellent signal quality?
  -- TODO: bssid
  -- TODO: popup widget to display detailed info below
  wifi.connected = false
  wifi.ssid = ""
  wifi.rate = ""
  wifi.signal = 0
  wifi.security = ""

  watch("nmcli -t -c no -w 2 -f IN-USE,SSID,RATE,SIGNAL,SECURITY dev wifi list", timeout, function(widget, stdout)
    for s in stdout:gmatch("[^\r\n$]+") do
      local in_use, ssid, rate, signal, security = string.match(s, "(.*):(.*):(.*):(.*):(.*)")

      in_use = string.gsub(in_use, "[%s]+", "")
      signal = tonumber(signal)

      if in_use == "*" then
        wifi.connected = true
        wifi.ssid = ssid
        wifi.rate = rate
        wifi.signal = tonumber(signal)
        wifi.security = security
      end
    end

    local highlight
    if not wifi.connected then
      highlight = beautiful.fg_critical
    elseif wifi.signal > 88 then
      highlight = beautiful.fg_normal
    elseif wifi.signal > 70 then
      highlight = beautiful.fg_focus
    elseif wifi.signal > 30 then
      highlight = beautiful.fg_urgent
    else
      highlight = beautiful.fg_critical
    end

    widget:get_children_by_id("text")[1]:set_text((" %d%%"):format(wifi.signal))
    widget:set_fg(highlight)
  end, wifi)

  return wifi
end

return setmetatable(wifi, {
  __call = function(_, ...)
    return worker(...)
  end,
})
