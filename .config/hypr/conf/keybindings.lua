local s = require("conf.settings")
local mod = s.mod

local function bind(keys, dispatcher, description, opts)
    opts = opts or {}
    opts.description = description
    hl.bind(keys, dispatcher, opts)
end

local exec = hl.dsp.exec_cmd

bind(mod .. " + B",      exec(s.browser),          "Browser")
bind(mod .. " + C",      exec(s.hyprconfig),       "Edit Hyprland config")
bind(mod .. " + D",      exec(s.menu),             "App launcher")
bind(mod .. " + E",      exec(s.editor),           "Editor (project picker)")
bind(mod .. " + F",      hl.dsp.window.fullscreen({ mode = "maximized" }), "Maximize window")
bind(mod .. " + H",      hl.dsp.window.resize({ x = -40, y = 0, relative = true }), "Shrink window")
bind(mod .. " + J",      hl.dsp.window.cycle_next({ next = false }), "Focus previous window")
bind(mod .. " + K",      hl.dsp.window.cycle_next(), "Focus next window")
bind(mod .. " + L",      hl.dsp.window.resize({ x = 40, y = 0, relative = true }), "Grow window")
bind(mod .. " + Q",      exec(s.screenlock),       "Lock screen")
bind(mod .. " + S",      exec(s.keybindings),      "Show keybindings")
bind(mod .. " + T",      exec(s.todo),             "Todo")
bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }), "Toggle floating")
bind(mod .. " + RETURN", exec(s.terminal),         "Terminal")
bind(mod .. " + TAB",    exec(s.statusbar_toggle), "Toggle status bar")

bind(mod .. " + SHIFT + C",      hl.dsp.window.close(),       "Close window")
bind(mod .. " + SHIFT + E",      exec(s.filemngr),            "File manager")
bind(mod .. " + SHIFT + F",      exec(s.screenshot),          "Screenshot (region)")
bind(mod .. " + SHIFT + T",      exec(s.btop),                "btop")
bind(mod .. " + SHIFT + Q",      exec(s.power_menu),          "Power menu")
bind(mod .. " + SHIFT + RETURN", hl.dsp.layout("swapwithmaster"), "Swap with master")

for i = 1, 10 do
    local key = i % 10 -- workspace 10 is on key 0
    bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }),       "Workspace " .. i)
    bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), "Move to workspace " .. i)
end

bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")
bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   "Move window",   { mouse = true })
bind(mod .. " + mouse:273",  hl.dsp.window.resize(), "Resize window", { mouse = true })

bind("XF86AudioRaiseVolume",          exec("pactl set-sink-volume @DEFAULT_SINK@ +5%"),     "Volume up",     { repeating = true })
bind("XF86AudioLowerVolume",          exec("pactl set-sink-volume @DEFAULT_SINK@ -5%"),     "Volume down",   { repeating = true })
bind(mod .. " + XF86AudioRaiseVolume", exec("pactl set-source-volume @DEFAULT_SOURCE@ +5%"), "Mic volume up",   { repeating = true })
bind(mod .. " + XF86AudioLowerVolume", exec("pactl set-source-volume @DEFAULT_SOURCE@ -5%"), "Mic volume down", { repeating = true })
bind("XF86AudioMute",                 exec("pactl set-sink-mute @DEFAULT_SINK@ toggle"),     "Mute")
bind("XF86AudioMicMute",              exec("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), "Mute mic")
bind("XF86MonBrightnessDown",         exec("~/.config/hypr/scripts/brightness.sh down"),    "Brightness down", { repeating = true })
bind("XF86MonBrightnessUp",           exec("~/.config/hypr/scripts/brightness.sh up"),      "Brightness up",   { repeating = true })
