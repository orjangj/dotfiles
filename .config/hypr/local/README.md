# local/ — machine-local Hyprland config

Per-machine config that should not live in the tracked dotfiles: work-only binds,
a desk's monitor layout, host-specific autostarts.

`hyprland.lua` loads every `local/*.lua` in alphabetical order, after `conf/`,
so settings here override the defaults. An empty directory is fine.

Each file is plain Hyprland Lua (`hl.bind(...)`, `hl.monitor(...)`, ...) and can
`require("conf.settings")` / `require("conf.colors")`. Example: `work.lua`.
