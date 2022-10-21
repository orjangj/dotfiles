local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")

local storage = {}

local function worker()
  local timeout = 300
  local space = {
    ["good"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["urgent"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["critical"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
  }

  -- TODO: Spacing between other widgets
  local textbox = wibox.widget({
    markup = space["good"].symbol,
    font = beautiful.font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  storage = wibox.widget({
    textbox,
    fg = space["good"].fg,
    bg = space["good"].bg,
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

    local type
    if used_percentage >= 70 and used_percentage < 90 then
      type = space["urgent"]
    elseif used_percentage >= 90 then
      type = space["critical"]
    else
      type = space["good"]
    end

    widget.widget.markup = type.symbol .. " " .. used_percentage .. "%"
    widget.fg = type.fg
    widget.bg = type.bg

  end, storage)

  return storage
end

return setmetatable(storage, {
  __call = function(_, ...)
    return worker(...)
  end,
})
