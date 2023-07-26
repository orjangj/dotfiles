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
--
-- TODO:
-- - Learn XResources and what not
-- - Add scratchpad support
-- - Cleanup unused/redundant code
-- - keybindings (remove unused, apply better keys, etc.. ???)
-- - Use rofi scripts to save keybindings?
-- - Automatic screen lock (see sway config for ideas)
--   - Could use a gears.timer to check inactivity?
--   - Customize i3lock

-- Awesome libraries
local gears = require("gears")
local awful = require("awful")
local _ = require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local xrandr = require("module.xrandr")

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

local configs = gears.filesystem.get_configuration_dir()
local altkey = "Mod2"
local browser = "firefox"
local compositor = "picom -b"
local editor = os.getenv("EDITOR") or "nvim"
local file_manager = "ranger"
local modkey = "Mod4"
local tags = { count = 6, glyphs = { "    ", "    ", "    ", "    ", "    ", "    " } }
local terminal = "kitty"
local theme = "nord"
local wallpapers = os.getenv("HOME") .. "/.local/share/backgrounds/wallpapers/nord"

-- This should always be run before loading user widgets as they might depend
-- on the color theme
beautiful.init(configs .. "themes/" .. theme .. "/theme.lua")

--}}}
-- {{{ User specific widgets

local battery = require("widget.battery")
local brightness = require("widget.brightness")
local cpu = require("widget.cpu")
local microphone = require("widget.mic")
local ram = require("widget.ram")
local storage = require("widget.storage")
local volume = require("widget.volume")
local temperature = require("widget.temperature")
local wifi = require("widget.wifi")

-- }}}
-- {{{ Layout

awful.layout.layouts = {
  awful.layout.suit.tile,
}

-- }}}
-- {{{ Menu

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- }}}
-- {{{ Wibar

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 3, awful.tag.viewtoggle)
)

-- TODO
-- Make wibar look like waybar config
-- Make rofi look like wofi config
-- MasterStack layout - How to make master size a bit larger by default? Say 60 vs 40 %
-- Check lain/vicious for ideas on widget implementation
-- Implement wallpaper setter instead of relying on feh

-- Used for creating spacing on left/right of horizontal layout when specifying spacing
local dummy_widget = wibox.widget({
  text = "",
  widget = wibox.widget.textbox,
})

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Each screen has its own tag table.
  awful.tag(tags.glyphs, s, awful.layout.layouts[1])

  -- Create a taglist widget that can be used in the wibar
  s.mytaglist = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  -- Make the wibar look like it's floating
  s.mywibox = awful.wibar({
    position = "top",
    screen = s,
    height = dpi(36),
    bg = beautiful.transparent,
  })

  s.mywibox:setup({
    {
      layout = wibox.layout.stack,
      {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
          {
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
          },
          bg = beautiful.bg_normal .. "EF",
          shape_border_width = beautiful.border_width,
          shape_border_color = beautiful.border_focus .. "BF",
          shape = gears.shape.rounded_rect,
          widget = wibox.container.background,
        },
        nil,
        { -- Right widgets
          {
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            dummy_widget,
            wifi(),
            cpu(),
            temperature(),
            ram(),
            storage(),
            brightness(),
            volume(),
            microphone(),
            battery(),
            dummy_widget,
          },
          bg = beautiful.bg_normal .. "EF",
          shape = gears.shape.rounded_rect,
          shape_border_width = beautiful.border_width,
          shape_border_color = beautiful.border_focus .. "BF",
          widget = wibox.container.background,
        },
      },
      { -- Center widgets
        {
          {
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
            dummy_widget,
            wibox.widget.textclock(" %a %d/%m    %H:%M"),
            dummy_widget,
          },
          bg = beautiful.bg_normal .. "EF",
          shape = gears.shape.rounded_rect,
          shape_border_width = beautiful.border_width,
          shape_border_color = beautiful.border_focus .. "BF",
          forced_height = dpi(36),
          widget = wibox.container.background,
        },
        layout = wibox.container.place,
        valign = "center",
        halign = "center",
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

local globalkeys = gears.table.join(
  -- Group "awesome"
  awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "reload awesome", group = "awesome" }),
  awful.key({ modkey, "Shift" }, "q", function()
    awful.spawn(configs .. "scripts/power_menu.sh")
  end, { description = "power menu", group = "awesome" }),
  awful.key({ modkey }, "q", function()
    awful.spawn("i3lock -c 000000")
  end, { description = "lock screen", group = "awesome" }),

  -- Group "launcher"
  awful.key({ modkey }, "Return", function()
    awful.spawn(terminal)
  end, { description = "open a terminal", group = "launcher" }),
  awful.key({ modkey }, "e", function()
    awful.spawn(terminal .. " -e nvim")
  end, { description = "open editor", group = "launcher" }),
  awful.key({ modkey }, "b", function()
    awful.spawn(browser)
  end, { description = "open a browser", group = "launcher" }),
  awful.key({ modkey }, "d", function()
    awful.spawn("rofi -no-lazy-grab -show drun")
  end, { description = "launch rofi", group = "launcher" }),
  awful.key({ modkey }, "p", function()
    menubar.show()
  end, { description = "show the menubar", group = "launcher" }),
  awful.key({ modkey }, "a", function()
    awful.spawn(terminal .. " -e " .. file_manager .. " " .. os.getenv("HOME"))
  end, { description = "open " .. file_manager, group = "launcher" }),
  awful.key({ modkey, "Control" }, "f", function()
    awful.spawn("flameshot gui")
  end, { description = "Run flameshot", group = "launcher" }),

  -- Group "tag"
  awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
  awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

  -- Group "screen"
  awful.key(
    { modkey, "Control" },
    "x",
    function()
      xrandr.xrandr()
    end, -- TODO: May have to restart compositor after changing setup
    { description = "multimonitor setup", group = "screen" }
  ),
  awful.key({ modkey, "Control" }, "j", function()
    awful.screen.focus_relative(1)
  end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function()
    awful.screen.focus_relative(-1)
  end, { description = "focus the previous screen", group = "screen" }),

  -- Group "client"
  awful.key({ modkey }, "j", function()
    awful.client.focus.byidx(1)
  end, { description = "focus next by index", group = "client" }),
  awful.key({ modkey }, "k", function()
    awful.client.focus.byidx(-1)
  end, { description = "focus previous by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "j", function()
    awful.client.swap.byidx(1)
  end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function()
    awful.client.swap.byidx(-1)
  end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey }, "Tab", function()
    awful.client.focus.history.previous()
    if client.focus then
      client.focus:raise()
    end
  end, { description = "go back", group = "client" }),
  awful.key({ modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, { description = "restore minimized", group = "client" }),

  -- Group "layout"
  awful.key({ modkey }, "l", function()
    awful.tag.incmwfact(0.02)
  end, { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey }, "h", function()
    awful.tag.incmwfact(-0.02)
  end, { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift" }, "h", function()
    awful.tag.incnmaster(1, nil, true)
  end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift" }, "l", function()
    awful.tag.incnmaster(-1, nil, true)
  end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey }, "space", function()
    awful.layout.inc(1)
  end, { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function()
    awful.layout.inc(-1)
  end, { description = "select previous", group = "layout" }),

  -- Hidden/Ungrouped (laptop) keys
  awful.key({}, "XF86AudioRaiseVolume", function()
    volume:inc(5)
  end),
  awful.key({}, "XF86AudioLowerVolume", function()
    volume:dec(5)
  end),
  awful.key({}, "XF86AudioMute", function()
    volume:toggle()
  end),
  awful.key({ modkey }, "XF86AudioRaiseVolume", function()
    microphone:inc(5)
  end),
  awful.key({ modkey }, "XF86AudioLowerVolume", function()
    microphone:dec(5)
  end),
  awful.key({}, "XF86AudioMicMute", function()
    microphone:toggle()
  end),
  awful.key({}, "XF86MonBrightnessDown", function()
    brightness:dec(5)
  end),
  awful.key({}, "XF86MonBrightnessUp", function()
    brightness:inc(5)
  end)
)

local clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey, "Shift" }, "c", function(c)
    c:kill()
  end, { description = "close", group = "client" }),
  awful.key(
    { modkey, "Control" },
    "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),
  awful.key({ modkey, "Control" }, "Return", function(c)
    c:swap(awful.client.getmaster())
  end, { description = "move to master", group = "client" }),
  awful.key({ modkey }, "o", function(c)
    c:move_to_screen()
  end, { description = "move to screen", group = "client" }),
  awful.key({ modkey }, "t", function(c)
    c.ontop = not c.ontop
  end, { description = "toggle keep on top", group = "client" }),
  awful.key({ modkey }, "n", function(c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
  end, { description = "minimize", group = "client" }),
  awful.key({ modkey }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = "(un)maximize", group = "client" }),
  awful.key({ modkey, "Control" }, "m", function(c)
    c.maximized_vertical = not c.maximized_vertical
    c:raise()
  end, { description = "(un)maximize vertically", group = "client" }),
  awful.key({ modkey, "Shift" }, "m", function(c)
    c.maximized_horizontal = not c.maximized_horizontal
    c:raise()
  end, { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        tag:view_only()
      end
    end, { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local screen = awful.screen.focused()
      local tag = screen.tags[i]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end, { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end, { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then
          client.focus:toggle_tag(tag)
        end
      end
    end, { description = "toggle focused client on tag #" .. i, group = "tag" })
  )
end

local clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
  end),
  awful.button({ modkey }, 1, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.move(c)
  end),
  awful.button({ modkey }, 3, function(c)
    c:emit_signal("request::activate", "mouse_click", { raise = true })
    awful.mouse.client.resize(c)
  end)
)

-- Set keys
root.keys(globalkeys)

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
      keys = clientkeys,
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

awesome.connect_signal("exit", function(reason_restart)
  if not reason_restart then
    return
  end

  local file = io.open("/tmp/awesomewm-last-selected-tags", "w+")

  for s in screen do
    file:write(s.selected_tag.index, "\n")
  end

  file:close()
end)

awesome.connect_signal("startup", function()
  local file = io.open("/tmp/awesomewm-last-selected-tags", "r")
  if not file then
    return
  end

  local selected_tags = {}

  for line in file:lines() do
    table.insert(selected_tags, tonumber(line))
  end

  for s in screen do
    local i = selected_tags[s.index]
    local t = s.tags[i]
    t:view_only()
  end

  file:close()
end)

-- }}}
-- Autostart {{{
local function run_once(cmd)
  local findme = cmd
  local firstspace = cmd:find(" ")
  if firstspace then
    findme = cmd:sub(0, firstspace - 1)
  end
  awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

awful.spawn.with_shell("xset r rate 200 40")
awful.spawn.with_shell("feh --randomize --bg-fill " .. wallpapers)
run_once(compositor)
-- }}}
