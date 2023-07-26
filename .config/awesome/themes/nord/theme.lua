local dpi = require("beautiful.xresources").apply_dpi
local gears = require("gears")

local theme = {}

theme.name = "nord"
theme.font = "Ubuntu Nerd Font 11"

-- For reference only
theme.nord0  = "#2e3440"
theme.nord1  = "#3b4252"
theme.nord2  = "#434c5e"
theme.nord3  = "#4c566a"
theme.nord4  = "#d8dee9"
theme.nord5  = "#e5e9f0"
theme.nord6  = "#eceff4"
theme.nord7  = "#8fbcbb"
theme.nord8  = "#88c0d0"
theme.nord9  = "#81a1c1"
theme.nord10 = " #5e81ac"
theme.nord11 = " #bf616a"
theme.nord12 = " #d08770"
theme.nord13 = " #ebcb8b"
theme.nord14 = " #a3be8c"
theme.nord15 = " #b48ead"

theme.normal      = "#2E3440"
theme.green       = "#A3BE8C"
theme.teal        = "#88C0D0"
theme.orange      = "#D08770"
theme.red         = "#BF616A"
theme.yellow      = "#EBCB8B"
theme.black       = "#000000"
theme.transparent = "#2E344000"

theme.fg_normal   = "#E5E9F0"
theme.fg_focus    = "#88C0D0"
theme.fg_urgent   = "#D08770"
theme.fg_critical = "#BF616A"

theme.bg_normal   = "#2e3440"
theme.bg_focus    = "#3b4252"
theme.bg_urgent   = "#434c5e"
theme.bg_critical = "#4c566a"
theme.bg_systray  = theme.bg_normal

theme.border_normal   = "#3B4252"
theme.border_focus    = "#88C0D0"
theme.border_marked   = "#D08770"
theme.border_critical = "#BF616A"
theme.border_width    = dpi(2)

theme.titlebar_bg_focus = "#3B4252"
theme.titlebar_bg_normal = "#2E3440"

theme.useless_gap = dpi(3)
theme.wibox_spacing = dpi(8)

-- TAGLIST {{{
--theme.taglist_bg_focus = "#88C0D0"
--theme.taglist_fg_focus = theme.bg_normal
theme.taglist_fg_empty = theme.bg_urgent
theme.taglist_fg_occupied = "#7b88a1"
theme.taglist_shape = gears.shape.rounded_rect
theme.taglist_spacing = dpi(5)
-- }}}

--theme.fg_widget        = "#A3BE8C"
--theme.fg_center_widget = "#8FBCBB"
--theme.fg_end_widget    = "#BF616A"
--theme.bg_widget        = "#434C5E"
--theme.border_widget    = "#3B4252"

theme.mouse_finder_color = "#D08770"

theme.wibar_border_color = theme.nord7

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- HOTKEYS {{{
theme.hotkeys_font = theme.font
--theme.hotkeys_description_font = theme.font -- Issue: cannot set color?
theme.hotkeys_bg = theme.bg_normal
theme.hotkeys_fg = theme.fg_normal
theme.hotkeys_label_bg = theme.fg_focus  -- See https://github.com/awesomeWM/awesome/issues/3773
theme.hotkeys_lagel_fg = theme.bg_normal
theme.hotkeys_border_color = theme.border_focus
theme.hotkeys_modifiers_fg = theme.fg_normal
-- }


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
