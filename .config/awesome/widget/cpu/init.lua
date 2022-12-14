local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local CPU_CMD = [[grep --max-count=1 '^cpu.' /proc/stat]]

local cpu = {}

-- TODO: Dropdown list with action buttons?

local function worker()
  local timeout = 2

  cpu = wibox.widget({
    {
      {
        id = "text",
        widget = wibox.widget.textbox,
      },
      left = 4,
      right = 4,
      layout = wibox.container.margin,
    },
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 4)
    end,
    widget = wibox.container.background,
  })

  local maincpu = {}
  watch(CPU_CMD, timeout, function(widget, stdout)
    local _, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
    stdout:match("(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)")

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - tonumber(maincpu["idle_prev"] == nil and 0 or maincpu["idle_prev"])
    local diff_total = total - tonumber(maincpu["total_prev"] == nil and 0 or maincpu["total_prev"])
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    maincpu["total_prev"] = total
    maincpu["idle_prev"] = idle

    local highlight
    if diff_usage > 80 then
      highlight = beautiful.fg_critical
    elseif diff_usage > 50 then
      highlight = beautiful.fg_urgent
    elseif diff_usage > 30 then
      highlight = beautiful.fg_focus
    else
      highlight = beautiful.fg_normal
    end
    widget:get_children_by_id("text")[1]:set_text(" " .. math.floor(diff_usage) .. "%")
    widget:set_fg(highlight)
  end, cpu)

  return cpu
end

return setmetatable(cpu, {
  __call = function(_, ...)
    return worker(...)
  end,
})
