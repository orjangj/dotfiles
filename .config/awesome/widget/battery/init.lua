--------------------------------------------------
--- Battery Widget for Awesome Window Manager
--- Shows the battery status using the ACPI tool
--------------------------------------------------

local beautiful = require("beautiful")
local naughty = require("naughty")
local watch = require("awful.widget.watch")
local wibox = require("wibox")

local battery_widget = {}

local function worker()
  -- Configuration
  local timeout = 10 -- how often (in seconds) then watcher function runs
  -- NOTE: The icons/glyphs are from "Material Design"
  local discharging = {
    [10] = { bg = beautiful.bg_normal, fg = beautiful.fg_critical, symbol = "" },
    [20] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    [30] = { bg = beautiful.bg_normal, fg = beautiful.fg_urgent, symbol = "" },
    [40] = { bg = beautiful.bg_normal, fg = beautiful.fg_focus, symbol = "" },
    [50] = { bg = beautiful.bg_normal, fg = beautiful.fg_focus, symbol = "" },
    [60] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    [70] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    [80] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    [90] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
    [100] = { bg = beautiful.bg_normal, fg = beautiful.fg_normal, symbol = "" },
  }
  local charging = {
    bg = beautiful.bg_normal,
    fg = beautiful.fg_normal,
    symbol = "",
  }
  local last_battery_check = os.time()

  -- TODO: Spacing between other widgets
  local battery_textbox = wibox.widget({
    markup = discharging[100].symbol .. " 100%", -- initial condition
    font = beautiful.font,
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  battery_widget = wibox.widget({
    battery_textbox,
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
      if charge >= 0 and charge < 15 then
        type = discharging[10]
        if os.difftime(os.time(), last_battery_check) > 300 then
          -- if 5 minutes have elapsed since the last warning
          last_battery_check = os.time()
          show_battery_warning()
        end
      elseif charge >= 15 and charge < 25 then
        type = discharging[20]
      elseif charge >= 25 and charge < 35 then
        type = discharging[30]
      elseif charge >= 35 and charge < 45 then
        type = discharging[40]
      elseif charge >= 45 and charge < 55 then
        type = discharging[50]
      elseif charge >= 55 and charge < 65 then
        type = discharging[60]
      elseif charge >= 75 and charge < 85 then
        type = discharging[70]
      elseif charge >= 85 and charge < 95 then
        type = discharging[80]
      else
        -- TODO: 100?
        type = discharging[90]
      end
    end

    widget.widget.markup = type.symbol .. " " .. ("%d"):format(charge) .. "%"
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
