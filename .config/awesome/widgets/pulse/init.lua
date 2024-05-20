local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local pulse = {}

local function worker()
  local timeout = 20 -- default worker period
  local step = 5 -- default volume step increment
  local info = {}
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

  -- Parse sinks or sources output
  local function parse(raw, name)
    local volume, muted = "", false
    for str in string.gmatch(raw .. "\n\n", "(.-)\n\n") do
      local n = string.match(str, ".*Name: (.-)\n")
      if n == name then
        volume = string.match(str, ".*Volume: front%-left:.-/%s+(.-)%s+/")
        if volume == nil then
          -- The mic may be configured as mono input
          volume = string.match(str, ".*Volume: mono:.-/%s+(.-)%s+/")
        end
        muted = string.match(str, ".*Mute: (.-)\n")
      end
    end
    return volume, muted == "yes"
  end

  _, pulse.watcher = watch("pactl info", timeout, function(widget, info_stdout)
    info.default_sink_name = string.match(info_stdout, "Default Sink: (.-)\n")
    info.default_source_name = string.match(info_stdout, "Default Source: (.-)\n")

    spawn.easy_async("pactl list sinks", function(sinks_stdout)
      local volume, muted = parse(sinks_stdout, info.default_sink_name)
      local icon = muted and icons.sink.muted
        or string.find(info.default_sink_name, "bluez") and icons.sink.headphone
        or icons.sink.default
      widget
        :get_children_by_id("sink")[1]
        :set_markup_silently(("<span foreground='%s'>%s %s</span>"):format(muted and beautiful.red or beautiful.fg_normal, icon, volume))
    end)

    spawn.easy_async("pactl list sources", function(sources_stdout)
      local volume, muted = parse(sources_stdout, info.default_source_name)
      local icon = muted and icons.source.muted or icons.source.default
      widget
        :get_children_by_id("source")[1]
        :set_markup_silently(("<span foreground='%s'>%s %s</span>"):format(muted and beautiful.red or beautiful.fg_normal, icon, volume))
    end)
  end, pulse.widget)

  function pulse:volume_increase(channel, amount)
    amount = amount or step
    channel = channel or "sink"
    spawn.easy_async(
      "pactl set-" .. channel .. "-volume @DEFAULT_" .. string.upper(channel) .. "@ +" .. amount .. "%",
      function()
        pulse.watcher:emit_signal("timeout")
      end
    )
  end

  function pulse:volume_decrease(channel, amount)
    amount = amount or step
    channel = channel or "sink"
    spawn.easy_async(
      "pactl set-" .. channel .. "-volume @DEFAULT_" .. string.upper(channel) .. "@ -" .. amount .. "%",
      function()
        pulse.watcher:emit_signal("timeout")
      end
    )
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
