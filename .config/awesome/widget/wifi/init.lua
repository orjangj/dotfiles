local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local wifi = {}

local function worker()
  local timeout = 5
  local quality = {
    ["off"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
    ["critical"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
    ["bad"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["good"] = { bg = beautiful.bg_normal, fg = beautiful.fg_focus, symbol = "" },
    ["excellent"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
  }

  wifi = wibox.widget({
    {
      markup = quality["off"].symbol .. "0%",
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = beautiful.fg_normal,
    bg = beautiful.bg_normal,
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

--      show_warning(("name: %s, connected: (%s), bssid: %s"):format(ssid, in_use, bssid))

      if in_use == "*" then
        wifi.connected = true
        wifi.ssid = ssid
        wifi.rate = rate
        wifi.signal = tonumber(signal)
        wifi.security = security
      end
    end

    local type
    if not wifi.connected then
      type = quality["off"]
    elseif wifi.signal > 88 then
      type = quality["excellent"]
    elseif wifi.signal > 70 then
      type = quality["good"]
    elseif wifi.signal > 30 then
      type = quality["bad"]
    else
      type = quality["critical"]
    end

    widget.widget.markup = ("%s %d%%"):format(type.symbol, wifi.signal)
    widget.fg = type.fg
    widget.bg = type.bg

    -- TODO: What is the icon widget used for here?
  end, wifi)

  return wifi
end

return setmetatable(wifi, {
  __call = function(_, ...)
    return worker(...)
  end,
})
