-- Entry point (Hyprland >= 0.57 reads only Lua config).
-- Modules live in conf/ and are loaded with require("conf.<name>").
-- conf.settings and conf.colors return tables that other modules require.

require("conf.animation")
require("conf.autostart")
require("conf.cursor")
require("conf.decoration")
require("conf.environment")
require("conf.input")
require("conf.keybindings")
require("conf.layout")
require("conf.misc")
require("conf.monitor")
require("conf.window")

-- Machine-local drop-ins: every local/*.lua, alphabetical, loaded last so it overrides.
-- An empty directory is fine.
local localDir = os.getenv("HOME") .. "/.config/hypr/local"
local ls = io.popen('ls -1 "' .. localDir .. '"/*.lua 2>/dev/null')
if ls then
    for path in ls:lines() do
        dofile(path)
    end
    ls:close()
end
