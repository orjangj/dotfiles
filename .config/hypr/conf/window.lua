local c = require("conf.colors")

hl.config({
    general = {
        gaps_in     = 2,
        gaps_out    = 5,
        border_size = 2,
        col = {
            active_border   = { colors = { c.border_active, c.border_inactive }, angle = 45 },
            inactive_border = { colors = { c.border_inactive, c.border_inactive_dim }, angle = 45 },
        },
        layout = "master",
    },
})

-- Floating, centered window; size is an expression ("80%" is not accepted)
local function float_center(name, match, size, extra)
    local rule = { name = name, match = match, float = true, center = true, size = size }
    for k, v in pairs(extra or {}) do
        rule[k] = v
    end
    hl.window_rule(rule)
end

float_center("tui-popups",  { title = "^(btop|nnn|todo)$" },                    "monitor_w*0.8 monitor_h*0.8")
float_center("keybindings", { title = "^keybindings$" },                        "monitor_w*0.6 monitor_h*0.7")
float_center("volume",      { title = "^Volume Control$" },                     "monitor_w*0.5 monitor_h*0.5")
-- File dialogs, e.g. Firefox save/upload
float_center("file-dialog", { title = "^(Save As|Open Files).*$" },             "monitor_w*0.8 monitor_h*0.8")
float_center("updates",     { title = "^(System Update|Firmware Update)$" },    "monitor_w*0.6 monitor_h*0.6")
float_center("qemu",        { class = "qemu" },        "monitor_w*0.9 monitor_h*0.9", { workspace = "4" })
float_center("virt-viewer", { class = "virt-viewer" }, "monitor_w*0.9 monitor_h*0.9", { workspace = "4" })

hl.window_rule({ name = "forticlient", match = { class = "^FortiClient$" }, float = true })
hl.window_rule({ name = "vncviewer",   match = { class = "^Vncviewer$" },   float = true })

hl.window_rule({ name = "slack", match = { class = "Slack" }, workspace = "3" })
