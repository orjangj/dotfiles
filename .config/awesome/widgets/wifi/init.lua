local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local wifi = {}

local function worker()
  local timeout = 5

  wifi = wibox.widget({
    id = "text",
    widget = wibox.widget.textbox,
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
      else
        wifi.connected = false
        wifi.ssid = ""
        wifi.rate = ""
        wifi.signal = 0
        wifi.security = ""
      end
    end

    local highlight
    local icon = "直"
    if not wifi.connected then
      highlight = beautiful.fg_critical
      icon = "睊"
    elseif wifi.signal > 88 then
      highlight = beautiful.fg_normal
    elseif wifi.signal > 70 then
      highlight = beautiful.fg_focus
    elseif wifi.signal > 30 then
      highlight = beautiful.fg_urgent
    else
      highlight = beautiful.fg_critical
    end

    widget
      :get_children_by_id("text")[1]
      :set_markup_silently(("<span foreground='%s'>%s %d%%</span>"):format(highlight, icon, wifi.signal))
  end, wifi)

  return wifi
end

return setmetatable(wifi, {
  __call = function(_, ...)
    return worker(...)
  end,
})
