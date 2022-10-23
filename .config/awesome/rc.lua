--       █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
--      ██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
--      ███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
--      ██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
--      ██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
--      ╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

-- WARNING: Using chrome/chromium seem to cause a lot of flicker. Often occurring while using BLE headset and listening on youtube.
--          Firefox does not have the same issue, although some flicker happen now and then.

-- FIX:
-- - Flickering -- See comment above. May want to check issues with awesome wm on github
-- - Volume
--   -- color is orange on startup?
--   -- Change symbol based on output source (i.e. headset vs speaker)
--     -- Look into using "pactl subscribe" to listen for events on headset connect/disconnect
-- - Wifi
--   - on hover, show the network name (SSID), BSSID, rate and security protocol
--   - on click, add options to connect to network
-- - Bluetooth
--   - on hover, show connected devices
--   - on click, add options to add new devices etc..
-- - calendar -- simplify and use beatiful theme -- move to middle or left of wibar? if left, then maybe tags should be middle
-- - logout -- simplify and use font glyphs instead of icon set
-- - Number of tag views (set to 5)
-- - Fonts -- See https://github.com/ryanoasis/nerd-fonts
-- - Compton transparency not working when reloading awesome wm config
-- - xset doesn't seem to always apply on startup -- reloading config works though...
--
-- TODO:
-- - Cleanup unused/redundant code
-- - Get list of all dependencies (i.e. xbacklight, pavucontrol, etc..)
-- - keybindings (remove unused, apply better keys, etc.. ???)
-- - dmenu vs rofi?
-- - Use dmenu or rofi scripts to save keybindings?
-- - Automatic screen lock (see sway config for ideas)
--   - Possible to use login manager?
--   - Currently using i3lock

-- Awesome libraries
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

-- User specific settings
local keys = require("user.keys")
local vars = require("user.variables")

-- This should always be run before loading user widgets
-- as they might depend on the color theme
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), vars.theme))

-- User specific widgets
local battery_widget = require("widget.battery")
local bluetooth_widget = require("widget.bluetooth")
local brightness_widget = require("widget.brightness")
local calendar_widget = require("widget.calendar")
local cpu_widget = require("widget.cpu")
local logout_widget = require("widget.logout")
local mic_widget = require("widget.mic")
local ram_widget = require("widget.ram")
local storage_widget = require("widget.storage")
local volume_widget = require("widget.volume")
local temperature_widget = require("widget.temperature")
local wifi_widget = require("widget.wifi")

-- {{{ Layout
awful.layout.layouts = {
  awful.layout.suit.tile,
}
-- }}}

-- {{{ Menu
menubar.utils.terminal = vars.terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ vars.modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ vars.modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

local mytextclock = wibox.widget.textclock()
local cw = calendar_widget({
  theme = beautiful.name,
  placement = "top_right",
})
mytextclock:connect_signal("button::press", function(_, _, _, button)
  if button == 1 then
    cw.toggle()
  end
end)

awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

  -- Create a taglist widget
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  -- Create the wibox
  s.mywibox = awful.wibar({ position = "top", screen = s })

  -- Add widgets to the wibox
  s.mywibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.mytaglist,
    },
    nil, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      spacing = beautiful.wibox_spacing,
      cpu_widget(),
      temperature_widget(),
      ram_widget(),
      storage_widget(),
      brightness_widget(),
      volume_widget(),
      mic_widget(),
      battery_widget(),
      wifi_widget(),
      bluetooth_widget(),
      mytextclock,
      logout_widget(),
    },
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
    findme = cmd:sub(0, firstspace-1)
  end
  awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

--awful.spawn.easy_async("autorandr --change")  -- Not sure this is needed, but it is slow to execute (2-3 seconds freeze)!!
awful.spawn.easy_async("xset r rate 200 40")
awful.spawn.easy_async("feh --randomize --bg-fill " .. vars.wallpapers)
run_once(vars.compositor)
