local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local storage = {}

local function worker()
  local timeout = 300

  storage = wibox.widget({
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

  watch([[bash -c "df | tail -n +2"]], timeout, function(widget, stdout)
    local used_percentage
    for line in stdout:gmatch("[^\r\n$]+") do
      -- filesystem, size, used, avail, perc, mount
      local _, _, _, _, perc, mount =
        line:match("([%p%w]+)%s+([%d%w]+)%s+([%d%w]+)%s+([%d%w]+)%s+([%d]+)%%%s+([%p%w]+)")

      -- rootfs
      if mount == "/" then
        used_percentage = tonumber(perc)
      end
    end

    local highlight
    if used_percentage > 90 then
      highlight = beautiful.fg_critical
    elseif used_percentage > 70 then
      highlight = beautiful.fg_urgent
    elseif used_percentage > 50 then
      highlight = beautiful.fg_focus
    else
      highlight = beautiful.fg_normal
    end

    widget:get_children_by_id("text")[1]:set_text((" %d%%"):format(used_percentage))
    widget:set_fg(highlight)
  end, storage)

  return storage
end

return setmetatable(storage, {
  __call = function(_, ...)
    return worker(...)
  end,
})
