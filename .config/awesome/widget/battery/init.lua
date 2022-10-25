local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local battery = {}

local function worker()
  local timeout = 10
  local last_battery_check = os.time()

  battery = wibox.widget({
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

  local function warning_notification(text)
    -- TODO: Fix border color
    naughty.notify({
      title = "Low battery charge",
      text = text,
      timeout = timeout,
      hover_timeout = 0.5,
      position = "top_right",
      bg = beautiful.red, -- Note: Make the background stand out
      fg = beautiful.fg_normal,
      width = 300,
      screen = mouse.screen,
    })
  end

  watch("acpi -i", timeout, function(widget, stdout)
    local battery_info = {}
    local capacities = {}

    for s in stdout:gmatch("[^\r\n]+") do
      local status, charge_str, _ = string.match(s, ".+: ([%a%s]+), (%d?%d?%d)%%,?(.*)")
      if status ~= nil then
        table.insert(battery_info, { status = status, charge = tonumber(charge_str) })
      else
        local cap_str = string.match(s, ".+:.+last full capacity (%d+)")
        table.insert(capacities, tonumber(cap_str))
      end
    end

    local capacity = 0
    for _, cap in ipairs(capacities) do
      capacity = capacity + cap
    end

    local charge = 0
    local status
    for i, bat in ipairs(battery_info) do
      if capacities[i] ~= nil then
        if bat.charge >= charge then
          -- use most charged battery status
          -- this is arbitrary, and maybe another metric should be used
          status = bat.status
        end

        charge = charge + bat.charge * capacities[i]
      end
    end
    charge = charge / capacity

    local icon, highlight
    if status == "Charging" then
      icon = ""
      highlight = beautiful.fg_normal
    else
      if charge < 7 then
        icon = ""
        highlight = beautiful.fg_critical
        local difftime = os.difftime(os.time(), last_battery_check)
        if difftime > 3*timeout then
          -- TODO: Consider entering hibernate/suspend
          warning_notification("Connect battery to charger!")
          last_battery_check = os.time()
        end
      elseif charge < 15 then
        icon = ""
        highlight = beautiful.fg_urgent
        local difftime = os.difftime(os.time(), last_battery_check)
        if difftime > 6*timeout then
          warning_notification("Connect battery to charger!")
          last_battery_check = os.time()
        end
      elseif charge < 37 then
        icon = ""
        highlight = beautiful.fg_focus
      elseif charge < 62 then
        icon = ""
        highlight = beautiful.fg_normal
      elseif charge < 87 then
        icon = ""
        highlight = beautiful.fg_normal
      else
        icon = ""
        highlight = beautiful.fg_normal
      end
    end

    widget:get_children_by_id("text")[1]:set_text(("%s %d%%"):format(icon, charge))
    widget:set_fg(highlight)
  end, battery)

  return battery
end

return setmetatable(battery, {
  __call = function(_, ...)
    return worker(...)
  end,
})
