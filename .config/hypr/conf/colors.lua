-- Nord color palette: local c = require("conf.colors")
local c = {}

c.nord0  = "rgba(2e3440ff)"
c.nord1  = "rgba(3b4252ff)"
c.nord2  = "rgba(434c5eff)"
c.nord3  = "rgba(4c566aff)"
c.nord4  = "rgba(d8dee9ff)"
c.nord5  = "rgba(e5e9f0ff)"
c.nord6  = "rgba(eceff4ff)"
c.nord7  = "rgba(8fbcbbff)"
c.nord8  = "rgba(88c0d0ff)"
c.nord9  = "rgba(81a1c1ff)"
c.nord10 = "rgba(5e81acff)"
c.nord11 = "rgba(bf616aff)"
c.nord12 = "rgba(d08770ff)"
c.nord13 = "rgba(ebcb8bff)"
c.nord14 = "rgba(a3be8cff)"
c.nord15 = "rgba(b48eadff)"

c.black    = c.nord0
c.gray     = c.nord2
c.offwhite = c.nord4
c.white    = c.nord5
c.teal     = c.nord7
c.cyan     = c.nord8
c.blue     = c.nord10
c.red      = c.nord11
c.yellow   = c.nord13
c.green    = c.nord14
c.magenta  = c.nord15

c.background          = c.nord0
c.surface             = c.nord1
c.shadow              = c.nord1
c.comments            = c.nord3
c.border              = c.nord3
c.border_inactive     = c.border
c.border_active       = c.cyan
c.border_inactive_dim = "rgba(4c566a44)"
c.shadow_color        = "rgba(2e3440dd)"

c.text = c.nord5

c.error   = c.red
c.warning = c.yellow
c.success = c.green
c.special = c.magenta

c.calm     = c.teal
c.accent   = c.cyan
c.tertiary = c.blue

return c
