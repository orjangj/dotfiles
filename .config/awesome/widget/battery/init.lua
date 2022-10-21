local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local battery_widget = {}

local function worker()
  local timeout = 30
  local discharging = {
    [0] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
    [25] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    [50] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    [75] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    [100] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
  }
  local charging = {
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    symbol = "",
  }
  local last_battery_check = os.time()

  battery_widget = wibox.widget({
    {
      markup = discharging[100].symbol,
      font = beautiful.font,
      align = "center",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    fg = discharging[100].fg,
    bg = discharging[100].bg,
    widget = wibox.container.background,
  })

  local function show_battery_warning()
    -- TODO: Fix border color
    naughty.notify({
      text = "The battery is dying",
      title = "WAAAH... We have a problem!!!",
      timeout = 25, -- show the warning for a longer time
      hover_timeout = 0.5,
      position = "top_right",
      bg = beautiful.fg_critical, -- Note: Make the background stand out
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
    for i, battery in ipairs(battery_info) do
      if capacities[i] ~= nil then
        if battery.charge >= charge then
          status = battery.status -- use most charged battery status
          -- this is arbitrary, and maybe another metric should be used
        end

        charge = charge + battery.charge * capacities[i]
      end
    end
    charge = charge / capacity

    local type
    if status == "Charging" then
      type = charging
    else
      if charge >= 0 and charge < 5 then
        type = discharging[0]
        if os.difftime(os.time(), last_battery_check) > timeout then
          last_battery_check = os.time()
          show_battery_warning()
        end
      elseif charge >= 5 and charge < 15 then
        type = discharging[25]
        if os.difftime(os.time(), last_battery_check) > 3 * timeout then
          last_battery_check = os.time()
          show_battery_warning()
        end
      elseif charge >= 15 and charge < 37 then
        type = discharging[25]
      elseif charge >= 37 and charge < 62 then
        type = discharging[50]
      elseif charge >= 62 and charge < 87 then
        type = discharging[75]
      else
        type = discharging[100]
      end
    end

    widget.widget.markup = ("%s %d%%"):format(type.symbol, charge)
    widget.fg = type.fg
    widget.bg = type.bg

    -- TODO: What is the icon widget used for here?
  end, battery_widget)

  return battery_widget
end

return setmetatable(battery_widget, {
  __call = function(_, ...)
    return worker(...)
  end,
})
