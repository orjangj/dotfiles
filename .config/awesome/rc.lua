--[[

 █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗    ██╗    ██╗███╗   ███╗
██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝    ██║    ██║████╗ ████║
███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗      ██║ █╗ ██║██╔████╔██║
██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝      ██║███╗██║██║╚██╔╝██║
██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗    ╚███╔███╔╝██║ ╚═╝ ██║
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝     ╚══╝╚══╝ ╚═╝     ╚═╝

--]]

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

-- Custom modules
local xrandr = require("module.xrandr")
local wp = require("module.wallpaper")

-- Global variables (exposed by Awesome itself)
local awesome = awesome
local client = client
local root = root
local screen = screen

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
--{{{ User specific settings

local configs = gears.filesystem.get_configuration_dir()
--local altkey = "Mod2"
local shell = os.getenv("SHELL") or "bash"
local terminal = "kitty"
local browser = "firefox"
--local editor = terminal .. " -- " .. shell .. " -i -c \"nvim\""
local editor = configs .. "scripts/kitty-session.sh"
local file_manager = terminal .. " --title custom-file-manager -- " .. shell .. " -i -c \"nnn -P 'p'\""
local modkey = "Mod4"
local tags = { count = 6, glyphs = { "    ", "    ", "    ", "    ", "    ", "    " } }
local theme = "nord"
local wallpapers = os.getenv("HOME") .. "/.local/share/backgrounds/wallpapers/nord"
local application_launcher = "rofi -no-lazy-grab -show drun"
local screenshot = "flameshot gui"
local power_menu = configs .. "scripts/power_menu.sh"
local locker = "i3lock -c 000000"
local todo = terminal .. " --title custom-todo -- " .. shell .. " -i -c \"nvim -c ':cd ~/notes' -c ':edit ~/notes/todo.norg'\""
local resource_monitor = terminal .. " --title custom-resource-monitor -- " .. shell .. " -i -c \"btop\""

--}}}
-- Theme {{{

-- This should always be run before loading user widgets as they might depend
-- on the color theme
beautiful.init(configs .. "themes/" .. theme .. "/theme.lua")

-- }}}
-- {{{ User specific widgets

local widgets = require("widgets")

-- }}}
-- {{{ Layout

awful.layout.layouts = { awful.layout.suit.tile }

-- }}}
-- {{{ Menu

menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- }}}
-- {{{ Wibar

local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end),
  awful.button({}, 3, awful.tag.viewtoggle)
)

-- Used for creating spacing on left/right of horizontal layout when specifying spacing
local dummy_widget = wibox.widget({ text = "", widget = wibox.widget.textbox })

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
  -- Set wallpaper for each screen
  gears.wallpaper.maximized(wp.random(wallpapers), s, true)

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
            widgets.wifi(),
            widgets.cpu(),
            widgets.temperature(),
            widgets.ram(),
            widgets.storage(),
            widgets.brightness(),
            widgets.pulse(),
            widgets.battery(),
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
  awful.key({ modkey            }, "s", hotkeys_popup.show_help, { description = "Show keybindings", group = "awesome" }),
  awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "Reload awesome", group = "awesome" }),
  awful.key({ modkey            }, "q", function() awful.spawn(locker) end, { description = "Lock screen", group = "awesome" }),
  awful.key({ modkey, "Shift"   }, "q", function() awful.spawn(power_menu) end, { description = "Power menu", group = "awesome" }),
  awful.key({ modkey            }, "Tab", function ()
    local statusbar = awful.screen.focused().mywibox
    statusbar.visible = not statusbar.visible
  end, { description = "Toggle statusbar", group = "awesome"}),
  awful.key({ modkey            }, "w", function()
    awful.screen.connect_for_each_screen(function(s)
      gears.wallpaper.maximized(wp.random(wallpapers), s, true)
    end)
  end, { description = "Change wallpaper", group = "awesome"}),

  -- Group "launcher"
  awful.key({ modkey            }, "Return", function() awful.spawn(terminal) end, { description = "Open terminal", group = "launcher" }),
  awful.key({ modkey            }, "e", function() awful.spawn(editor) end, { description = "Open editor", group = "launcher" }),
  awful.key({ modkey, "Shift"   }, "e", function() awful.spawn(file_manager) end, { description = "Open file manager", group = "launcher" }),
  awful.key({ modkey            }, "b", function() awful.spawn(browser) end, { description = "Open web browser", group = "launcher" }),
  awful.key({ modkey            }, "d", function() awful.spawn(application_launcher) end, { description = "Open application launcher", group = "launcher" }),
  awful.key({ modkey, "Control" }, "f", function() awful.spawn(screenshot) end, { description = "Open screenshot gui", group = "launcher" }),
  awful.key({ modkey            }, "t", function() awful.spawn(todo) end, { description = "Open Notes", group = "launcher" }),
  awful.key({ modkey, "Shift"   }, "t", function() awful.spawn(resource_monitor) end, { description = "Open file manager", group = "launcher" }),

  -- Group "tag"
  awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

  -- Group "screen"
  awful.key({ modkey, "Shift"   }, "x", function() awful.spawn("autorandr --change") end, { description = "Run Autorandr", group = "screen" }),
  awful.key({ modkey, "Control" }, "x", function() xrandr.xrandr() end, { description = "multimonitor setup", group = "screen" }),
  awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end, { description = "focus the next screen", group = "screen" }),
  awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end, { description = "focus the previous screen", group = "screen" }),

  -- Group "client"
  awful.key({ modkey            }, "j", function() awful.client.focus.byidx(1) end, { description = "focus next by index", group = "client" }),
  awful.key({ modkey            }, "k", function() awful.client.focus.byidx(-1) end, { description = "focus previous by index", group = "client" }),
  awful.key({ modkey, "Shift"   }, "j", function() awful.client.swap.byidx(1) end, { description = "swap with next client by index", group = "client" }),
  awful.key({ modkey, "Shift"   }, "k", function() awful.client.swap.byidx(-1) end, { description = "swap with previous client by index", group = "client" }),
  awful.key({ modkey            }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
  awful.key({ modkey, "Control" }, "n", function()
    local c = awful.client.restore()
    -- Focus restored client
    if c then
      c:emit_signal("request::activate", "key.unminimize", { raise = true })
    end
  end, { description = "restore minimized", group = "client" }),

  -- Group "layout"
  awful.key({ modkey            }, "l", function() awful.tag.incmwfact(0.02) end, { description = "increase master width factor", group = "layout" }),
  awful.key({ modkey            }, "h", function() awful.tag.incmwfact(-0.02) end, { description = "decrease master width factor", group = "layout" }),
  awful.key({ modkey, "Shift"   }, "h", function() awful.tag.incnmaster(1, nil, true) end, { description = "increase the number of master clients", group = "layout" }),
  awful.key({ modkey, "Shift"   }, "l", function() awful.tag.incnmaster(-1, nil, true) end, { description = "decrease the number of master clients", group = "layout" }),
  awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ modkey            }, "space", function() awful.layout.inc(1) end, { description = "select next", group = "layout" }),
  awful.key({ modkey, "Shift"   }, "space", function() awful.layout.inc(-1) end, { description = "select previous", group = "layout" }),

  -- Hidden/Ungrouped (laptop) keys
  awful.key({        }, "XF86AudioRaiseVolume", function() widgets.pulse:volume_increase("sink", 5) end),
  awful.key({        }, "XF86AudioLowerVolume", function() widgets.pulse:volume_decrease("sink", 5) end),
  awful.key({        }, "XF86AudioMute", function() widgets.pulse:volume_toggle("sink") end),
  awful.key({ modkey }, "XF86AudioRaiseVolume", function() widgets.pulse:volume_increase("source", 5) end),
  awful.key({ modkey }, "XF86AudioLowerVolume", function() widgets.pulse:volume_decrease("source", 5) end),
  awful.key({        }, "XF86AudioMicMute", function() widgets.pulse:volume_toggle("source") end),
  awful.key({        }, "XF86MonBrightnessDown", function() widgets.brightness:dec(5) end),
  awful.key({        }, "XF86MonBrightnessUp", function() widgets.brightness:inc(5) end)
)

local clientkeys = gears.table.join(
  awful.key({ modkey }, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end, { description = "toggle fullscreen", group = "client" }),
  awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end, { description = "close", group = "client" }),

  awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),
  awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end, { description = "move to master", group = "client" }),
  awful.key({ modkey            }, "o", function(c) c:move_to_screen() end, { description = "move to screen", group = "client" }),
  awful.key({ modkey            }, "t", function(c) c.ontop = not c.ontop end, { description = "toggle keep on top", group = "client" }),
  awful.key({ modkey            }, "n", function(c) c.minimized = true end, { description = "minimize", group = "client" }),
  awful.key({ modkey            }, "m", function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = "Toggle maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9, function()
      local tag = awful.screen.focused().tags[i]
      if tag then
        tag:view_only()
      end
    end, { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
      local tag = awful.screen.focused().tags[i]
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
    end, { description = "move focused client to tag #" .. i, group = "tag" })
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

  {
    rule_any = {
      name = {
        "custom-todo",
        "custom-file-manager",
        "custom-resource-monitor",
      }
    },
    properties = {
      floating = true,
      -- See https://github.com/awesomeWM/awesome/issues/2497
      placement = function(...) return awful.placement.centered(...) end,
      width = awful.screen.focused().geometry.width * 0.9,
      height = awful.screen.focused().geometry.height * 0.9,
    },
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
  if not file then
    return
  end

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
run_once("picom -b")

-- }}}
