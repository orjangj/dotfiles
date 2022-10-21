local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require("beautiful")

local CPU_CMD = [[grep --max-count=1 '^cpu.' /proc/stat]]

local cpu_widget = {}

-- TODO: Dropdown list with action buttons?

local function worker()
  local timeout = 2

  local load = {
    ["good"] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    ["urgent"] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    ["critical"] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
  }

  -- TODO: Spacing between other widgets
  local textbox = wibox.widget({
    markup = load["good"].symbol,
    font = beautiful.font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  cpu_widget = wibox.widget({
    textbox,
    fg = load["good"].fg,
    bg = load["good"].bg,
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

    local type
    if diff_usage >= 50 and diff_usage < 80 then
      type = load["urgent"]
    elseif diff_usage >= 80 then
      type = load["critical"]
    else
      type = load["good"]
    end
    widget.widget.markup = type.symbol .. " " .. math.floor(diff_usage) .. "%"
    widget.fg = type.fg
    widget.bg = type.bg
  end, cpu_widget)

  return cpu_widget
end

return setmetatable(cpu_widget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
