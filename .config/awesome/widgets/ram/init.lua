local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local ram = {}

local function worker()
  local timeout = 2

  ram = wibox.widget({
    id = "text",
    widget = wibox.widget.textbox,
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
    local free_percentage = getPercentage(total_free)

    local highlight
    if free_percentage < 20 then
      highlight = beautiful.fg_critical
    elseif free_percentage < 40 then
      highlight = beautiful.fg_urgent
    elseif free_percentage < 60 then
      highlight = beautiful.fg_focus
    else
      highlight = beautiful.fg_normal
    end

    widget:get_children_by_id("text")[1]:set_text(string.format(" %d%%", free_percentage))
    widget:set_fg(highlight)

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
