--[[

 █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗    ██╗    ██╗███╗   ███╗
██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝    ██║    ██║████╗ ████║
███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗      ██║ █╗ ██║██╔████╔██║
██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝      ██║███╗██║██║╚██╔╝██║
██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗    ╚███╔███╔╝██║ ╚═╝ ██║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝     ╚═╝

--]]

-- FIX:
-- - Font -- Need a good font for the wibar
-- - theme -- remove unecessary bloat
-- - Battery
--   - Automatically suspend when low battery.
--   - Or maybe use TLP (+ Powertop) for battery life management
--     - On fedora, power-profiles-daemon seems to be the best choice.. but only on fedora?
--   - Calculate rate statistics (i.e. linear extrapolation), and display on hover
-- - Volume
--   -- Change symbol based on output source (i.e. headset vs speaker)
--     -- Look into using "pactl subscribe" to listen for events on headset connect/disconnect
-- - Wifi
--   - on hover, show the network name (SSID), BSSID, rate and security protocol
--   - on click, add options to connect to network
-- - calendar -- simplify and use beatiful theme -- move to middle or left of wibar? if left, then maybe tags should be middle
-- - logout -- simplify and use font glyphs instead of icon set
--
-- TODO:
-- - Add scratchpad support
-- - Cleanup unused/redundant code
-- - keybindings (remove unused, apply better keys, etc.. ???)
-- - Use rofi scripts to save keybindings?
-- - Automatic screen lock (see sway config for ideas)
--   - Could use a gears.timer to check inactivity?
--   - Possible to use login manager?
--   - Currently using i3lock

-- Awesome libraries
local gears = require("gears")
local awful = require("awful")
local _ = require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

-- {{{ Error handling

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false

  awesome.connect_signal("debug::error", function(err)
    if in_error then
      return
    end

    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err),
    })

    in_error = false
  end)
end

--}}}
--{{{ User specific settings & theme

local keys = require("user.keys")
local vars = require("user.variables")

-- This should always be run before loading user widgets
-- as they might depend on the color theme
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), vars.theme))

--}}}
-- {{{ User specific widgets

local battery_widget = require("widget.battery")
local brightness_widget = require("widget.brightness")
local clock_widget = require("widget.clock")
local cpu_widget = require("widget.cpu")
local logout_widget = require("widget.logout")
local mic_widget = require("widget.mic")
local ram_widget = require("widget.ram")
local storage_widget = require("widget.storage")
local volume_widget = require("widget.volume")
local temperature_widget = require("widget.temperature")
local wifi_widget = require("widget.wifi")

-- }}}
-- {{{ Layout

awful.layout.layouts = {
  awful.layout.suit.tile,
}

-- }}}
-- {{{ Menu

menubar.utils.terminal = vars.terminal -- Set the terminal for applications that require it

-- }}}
-- {{{ Wibar

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({}, 3, awful.tag.viewtoggle)
)

local function right_tri(cr, width, height, degree)
  cr:move_to(18, 0)
  cr:line_to(0, 25)
  cr:line_to(18, 25)
  cr:close_path()
end

local function left_tri(cr, width, height, degree)
  cr:line_to(0, 25)
  cr:line_to(18, 0)
  cr:line_to(0, 0)
  cr:close_path()
end

local function mysep(color, shape)
  return wibox.widget({
    shape = shape,
    color = color,
    border_width = 0,
    forced_width = 18,
    widget = wibox.widget.separator,
  })
end

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag(vars.tags.glyphs, s, awful.layout.layouts[1])

  -- Create a taglist widget that can be used in the wibar
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
    style = {
      spacing = 6,
    },
  })

  -- Make the wibar look like it's floating
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    height = 8 * beautiful.useless_gap,
    bg = beautiful.transparent,
  })
  -- And now we add widgets to the wibox
  s.mywibox:setup({
    {
      layout = wibox.layout.align.horizontal,
      { -- Left widgets
        {
          layout = wibox.layout.fixed.horizontal,
          s.mytaglist,
        },
        bg = beautiful.bg_normal .. "EF",
        widget = wibox.container.background,
      },
      { -- Center widgets
        {
          layout = wibox.layout.fixed.horizontal,
        },
        bg = beautiful.bg_normal .. "EF",
        widget = wibox.container.background,
      },
      { -- Right widgets
        {
          layout = wibox.layout.fixed.horizontal,
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.transparent),
          cpu_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          temperature_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          ram_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          storage_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          brightness_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          volume_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          mic_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          battery_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.bg_critical),
          wifi_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, left_tri), beautiful.transparent),
          clock_widget(),
          wibox.container.background(mysep(beautiful.bg_critical, right_tri), beautiful.transparent),
          logout_widget(),
        },
        bg = beautiful.bg_normal .. "EF",
        widget = wibox.container.background,
      },
    },
    left = 2 * beautiful.useless_gap,
    right = 2 * beautiful.useless_gap,
    top = 2 * beautiful.useless_gap,
    widget = wibox.container.margin,
  })
end)
-- }}}
-- {{{ Key bindings
local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ vars.modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ vars.modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(keys.global)
-- }}}
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.client,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = { floating = true },
  },
}
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("focus", function(c)
  c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
  c.border_color = beautiful.border_normal
end)
-- }}}

-- Autostart
local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

awful.spawn.with_shell("xset r rate 200 40")
awful.spawn.with_shell("feh --randomize --bg-fill " .. vars.wallpapers)
run_once(vars.compositor)
