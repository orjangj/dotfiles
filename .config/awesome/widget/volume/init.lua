local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

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
  local device = "default"

  volume.widget = wibox.widget({
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

  _, volume.watcher = watch(GET_VOLUME_CMD(device), timeout, function(widget, stdout)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local volume_level = string.match(stdout, "(%d?%d?%d)%%")
    volume_level = tonumber(string.format("% 3d", volume_level))

    local icon, highlight
    if mute == "off" or volume_level == 0 then
      icon = ""
      highlight = beautiful.fg_urgent
    elseif volume_level >= 70 then
      icon = ""
      highlight = beautiful.fg_critical
    else
      icon = ""
      highlight = beautiful.fg_normal
    end

    widget:get_children_by_id("text")[1]:set_text(("%s %d%%"):format(icon, volume_level))
    widget:set_fg(highlight)
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

  return volume.widget
end

return setmetatable(volume, {
  __call = function(_, ...)
    return worker(...)
  end,
})
