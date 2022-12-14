local dpi = require("beautiful.xresources").apply_dpi

local theme = {}

theme.name = "nord"
theme.font = "Ubuntu 10"

-- For reference only
theme.nord0 = "#2e3440"
theme.nord1 = "#3b4252"
theme.nord2 = "#434c5e"
theme.nord3 = "#4c566a"
theme.nord4 = "#d8dee9"
theme.nord5 = "#e5e9f0"
theme.nord6 = "#eceff4"
theme.nord7 = "#8fbcbb"
theme.nord8 = "#88c0d0"
theme.nord9 = "#81a1c1"
theme.nord10 = " #5e81ac"
theme.nord11 = " #bf616a"
theme.nord12 = " #d08770"
theme.nord13 = " #ebcb8b"
theme.nord14 = " #a3be8c"
theme.nord15 = " #b48ead"

theme.fg_normal = "#ECEFF4"
theme.fg_focus = "#88C0D0"
theme.fg_urgent = "#D08770"
theme.fg_critical = "#BF616A"
theme.bg_normal = "#2E3440"
theme.bg_focus = "#3B4252"
theme.bg_urgent = "#3B4252"
theme.bg_critical = "#3B4252"
theme.bg_systray = theme.bg_normal
theme.border_normal = "#3B4252"
theme.border_focus = "#88C0D0"
theme.border_marked = "#D08770"
theme.border_critical = "#BF616A"
theme.titlebar_bg_focus = "#3B4252"
theme.titlebar_bg_normal = "#2E3440"

theme.useless_gap = dpi(4)
theme.border_width = dpi(1)
theme.wibox_spacing = dpi(8)

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
theme.taglist_fg_empty = theme.bg_focus

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#A3BE8C"
--theme.fg_center_widget = "#8FBCBB"
--theme.fg_end_widget    = "#BF616A"
--theme.bg_widget        = "#434C5E"
--theme.border_widget    = "#3B4252"

theme.normal = "#2E3440"
theme.green = "#A3BE8C"
theme.teal = "#88C0D0"
theme.orange = "#D08770"
theme.red = "#BF616A"
theme.yellow = "#EBCB8B"
theme.black = "#000000"
theme.transparent = "#00000000"

theme.mouse_finder_color = "#D08770"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
