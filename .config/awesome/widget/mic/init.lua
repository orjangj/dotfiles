local wibox = require("wibox")
local spawn = require("awful.spawn")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")

local function GET_MIC_CMD(device)
  return "amixer -D " .. device .. " sget Capture"
end

local function SET_MIC_CMD(device, value)
  return "amixer -D " .. device .. " sset Capture " .. value .. "%"
end

local function INC_MIC_CMD(device, step)
  return "amixer -D " .. device .. " sset Capture " .. step .. "%+"
end

local function DEC_MIC_CMD(device, step)
  return "amixer -D " .. device .. " sset Capture " .. step .. "%-"
end

local function TOG_MIC_CMD(device)
  return "amixer -D " .. device .. " sset Capture toggle"
end

local mic = {}

local function worker()
  local timeout = 3600
  local base = 80
  local step = 5
  local device = "pulse"

  local level = {
    mute = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
    low = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    medium = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    high = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
  }

  mic.widget = wibox.widget({
    {
      markup = level.medium.symbol,
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = level.medium.fg,
    bg = level.medium.bg,
    widget = wibox.container.background,
  })

  _, mic.watcher = watch(GET_MIC_CMD(device), timeout, function(widget, stdout)
    local mute = string.match(stdout, "%[(o%D%D?)%]")
    local mic_level = string.match(stdout, "(%d?%d?%d)%%")
    mic_level = tonumber(string.format("% 3d", mic_level))

    local type
    if mute == "off" or mic_level == 0 then
      type = level.mute
    elseif mic_level >= 90 then
      type = level.high
    elseif mic_level >= 30 then
      type = level.medium
    else
      type = level.low
    end

    widget.widget.markup = ("%s %d%%"):format(type.symbol, mic_level)
    widget.fg = type.fg
    widget.bg = type.bg
  end, mic.widget)

  function mic:set(v)
    spawn.easy_async(SET_MIC_CMD(device, v or base), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  function mic:inc(s)
    spawn.easy_async(INC_MIC_CMD(device, s or step), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  function mic:dec(s)
    spawn.easy_async(DEC_MIC_CMD(device, s or step), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  function mic:toggle()
    spawn.easy_async(TOG_MIC_CMD(device), function()
      mic.watcher:emit_signal("timeout")
    end)
  end

  return mic.widget
end

return setmetatable(mic, {
  __call = function(_, ...)
    return worker(...)
  end,
})
