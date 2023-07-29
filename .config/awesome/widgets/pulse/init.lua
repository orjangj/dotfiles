local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local naughty = require("naughty")

local json = require("widgets.pulse.json")

-- TODO: On session login, the volume displays ?%... is this becuase the pulseaudio server is not initialized?
-- Check if there are errors in async callback

local pulse = {}

local function worker()
  local timeout = 5 -- default worker period
  local step = 5 -- default volume step increment
  local info
  local icons = {
    sink = {
      default = "",
      headphone = "",
      muted = "",
    },
    source = {
      default = "",
      muted = "",
    },
  }

  pulse.widget = wibox.widget({
    {
      id = "sink",
      widget = wibox.widget.textbox,
    },
    {
      id = "source",
      widget = wibox.widget.textbox,
    },
    nil,
    layout = wibox.layout.fixed.horizontal,
    spacing = 10,
  })

  local function parse(raw, name)
    local j = json.parse(raw)
    local volume, muted = "", false

    for _, item in pairs(j) do
      if item.name == name then
        volume = item.volume["front-left"]["value_percent"]
        muted = item.mute
      end
    end
    return volume, muted
  end

  _, pulse.watcher = watch("pactl -f json info", timeout, function(widget, info_stdout)
    info = json.parse(info_stdout)

    spawn.easy_async("pactl -f json list sinks", function(sinks_stdout)
      local volume, muted = parse(sinks_stdout, info.default_sink_name)
      local icon = muted and icons.sink.muted
        or string.find(info.default_sink_name, "bluez") and icons.sink.headphone
        or icons.sink.default
      widget:get_children_by_id("sink")[1]:set_text(("%s %s"):format(icon, volume))
    end)

    spawn.easy_async("pactl -f json list sources", function(sources_stdout)
      local volume, muted = parse(sources_stdout, info.default_source_name)
      local icon = muted and icons.source.muted or icons.source.default
      widget:get_children_by_id("source")[1]:set_text(("%s %s"):format(icon, volume))
    end)
  end, pulse.widget)

  function pulse:volume_increase(channel, amount)
    amount = amount or step
    channel = channel or "sink"
    spawn.easy_async("pactl set-" .. channel .. "-volume @DEFAULT_" .. string.upper(channel) .. "@ +" .. amount .. "%", function()
      pulse.watcher:emit_signal("timeout")
    end)
  end

  function pulse:volume_decrease(channel, amount)
    amount = amount or step
    channel = channel or "sink"
    spawn.easy_async("pactl set-" .. channel .. "-volume @DEFAULT_" .. string.upper(channel) .. "@ -" .. amount .. "%", function()
      pulse.watcher:emit_signal("timeout")
    end)
  end

  function pulse:volume_toggle(channel)
    channel = channel or "sink"
    spawn.easy_async("pactl set-" .. channel .. "-mute @DEFAULT_" .. string.upper(channel) .. "@ toggle", function()
      pulse.watcher:emit_signal("timeout")
    end)
  end

  return pulse.widget
end

return setmetatable(pulse, {
  __call = function(_, ...)
    return worker(...)
  end,
})
