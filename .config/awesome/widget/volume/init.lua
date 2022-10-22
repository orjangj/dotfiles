local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")

local function GET_VOLUME_CMD(device)
  return "amixer -D " .. device .. " sget Master"
end

local function SET_VOLUME_CMD(device, value)
  return "amixer -D " .. device .. " sset Master " .. value .. "%"
end

local function INC_VOLUME_CMD(device, step)
  return "amixer -D " .. device .. " sset Master " .. step .. "%+"
end

local function DEC_VOLUME_CMD(device, step)
  return "amixer -D " .. device .. " sset Master " .. step .. "%-"
end

local function TOG_VOLUME_CMD(device)
  -- NOTE: LED on laptop not toggled if i.e. connected to BLE headset
  return "amixer -D " .. device .. " sset Master toggle"
end

local volume = {}

local function worker()
  local timeout = 3600
  local base = 20
  local step = 5
  local device = "pulse"

  local level = {
    ["mute"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["good"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["high"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
  }

  volume.widget = wibox.widget({
    {
      markup = level["good"].symbol,
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = level["good"].fg,
    bg = level["good"].bg,
    widget = wibox.container.background,
  })

  _, volume.watcher = watch(GET_VOLUME_CMD(device), timeout, function(widget, stdout)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume_level = string.match(stdout, "(%d?%d?%d)%%")
    volume_level = tonumber(string.format("% 3d", volume_level))

    local type
    if mute == "off" or volume_level == 0 then
      type = level["mute"]
    elseif volume_level >= 70 then
      type = level["high"]
    else
      type = level["good"]
    end

    widget.widget.markup = ("%s %d%%"):format(type.symbol, volume_level)
    widget.fg = type.fg
    widget.bg = type.bg
  end, volume.widget)

  function volume:set(v)
    spawn.easy_async(SET_VOLUME_CMD(device, v or base), function()
      volume.watcher:emit_signal("timeout")
    end)
  end

  function volume:inc(s)
    spawn.easy_async(INC_VOLUME_CMD(device, s or step), function()
      volume.watcher:emit_signal("timeout")
    end)
  end

  function volume:dec(s)
    spawn.easy_async(DEC_VOLUME_CMD(device, s or step), function()
      volume.watcher:emit_signal("timeout")
    end)
  end

  function volume:toggle()
    spawn.easy_async(TOG_VOLUME_CMD(device), function()
      volume.watcher:emit_signal("timeout")
    end)
  end

  -- set level before leaving
  volume:set(base)

  return volume.widget
end

return setmetatable(volume, {
  __call = function(_, ...)
    return worker(...)
  end,
})
