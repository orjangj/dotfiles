local awful = require("awful")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local utils = require("widgets.utils")

local keyboard = {}

local function worker()
  local timeout = 3600

  keyboard.widget = wibox.widget({
    id = "text",
    widget = wibox.widget.textbox,
  })

  _, keyboard.watcher = watch(
    [[bash -c "setxkbmap -query | grep -oP 'layout:\s+\K.*'"]],
    timeout,
    function(widget, stdout)
      -- remove any trailing whitespaces or newlines
      keyboard.layout = string.gsub(stdout, '%s+', '')

      local choices = utils.strsplit(keyboard.layout, ",")

      local active
      if utils.isempty(choices) then
        active = keyboard.layout
      else
        active = choices[1]
      end

      local highlight = beautiful.fg_normal

      widget
          :get_children_by_id("text")[1]
          :set_markup_silently(("<span foreground='%s'>  %s</span>"):format(highlight, active))
    end,
    keyboard.widget
  )

  -- Selects next layout
  keyboard.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    local choices = utils.strsplit(keyboard.layout, ",")
    if not utils.isempty(choices) then
      local tmp = table.remove(choices, 1)
      table.insert(choices, tmp)
      local new_layout = table.concat(choices, ",")
      spawn.easy_async("setxkbmap -layout " .. new_layout, function()
       keyboard.watcher:emit_signal("timeout")
      end)
    end
  end)))

  return keyboard.widget
end

return setmetatable(keyboard, {
  __call = function(_, ...)
    return worker(...)
  end,
})
