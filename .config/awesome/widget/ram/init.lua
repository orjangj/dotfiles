local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ram = {}

local function worker()
  local timeout = 2

  local memory = {
    ["good"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["bad"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["critical"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
  }

  local textbox = wibox.widget({
    markup = memory["good"].symbol,
    font = beautiful.font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  --- Main ram widget shown on wibar
  ram = wibox.widget({
    textbox,
    fg = memory["good"].fg,
    bg = memory["good"].bg,
    widget = wibox.widget.background,
  })

  --- Widget which is shown when user clicks on the ram widget
  local popup = awful.popup({
    ontop = true,
    visible = false,
    widget = {
      widget = wibox.widget.piechart,
      forced_height = 200,
      forced_width = 400,
      colors = {
        beautiful.fg_critical, -- used
        beautiful.fg_focus, -- free .. TODO: Change to green color
        beautiful.fg_urgent, -- cache
      },
    },
    shape = gears.shape.rounded_rect,
    border_color = beautiful.border_color_active,
    border_width = 1,
    offset = { y = 5 },
  })

  --luacheck:ignore 231
  local total_used, total_free
  local total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap

  local function getPercentage(value)
    return math.floor((100 * value) / (total + total_swap) + 0.5)
  end

  watch('bash -c "LANGUAGE=en_US.UTF-8 free | grep -z Mem.*Swap.*"', timeout, function(widget, stdout)
    total, used, free, shared, buff_cache, available, total_swap, used_swap, free_swap =
    stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*Swap:%s*(%d+)%s*(%d+)%s*(%d+)")

    total_used = used + used_swap
    total_free = free + free_swap
    local type
    local free_percentage = getPercentage(total_free)
    if free_percentage < 20 then
      type = memory["critical"]
    elseif free_percentage >= 20 and free_percentage < 40 then
      type = memory["bad"]
    else
      type = memory["good"]
    end

    widget.widget.markup = type.symbol .. " " .. free_percentage .. "%"
    widget.bg = type.bg
    widget.fg = type.fg

    if popup.visible then
      popup:get_widget().data_list = {
        { "used " .. getPercentage(total_used) .. "%", total_used },
        { "free " .. getPercentage(total_free) .. "%", total_free },
        { "cache " .. getPercentage(buff_cache) .. "%", buff_cache },
      }
    end
  end, ram)

  ram:buttons(awful.util.table.join(awful.button({}, 1, function()
    popup:get_widget().data_list = {
      { "used " .. getPercentage(total_used) .. "%", total_used },
      { "free " .. getPercentage(total_free) .. "%", total_free },
      { "cache " .. getPercentage(buff_cache) .. "%", buff_cache },
    }

    if popup.visible then
      popup.visible = not popup.visible
    else
      popup:move_next_to(mouse.current_widget_geometry)
    end
  end)))

  return ram
end

return setmetatable(ram, {
  __call = function(_, ...)
    return worker(...)
  end,
})
