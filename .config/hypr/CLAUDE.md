# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Hyprland (Wayland compositor) configuration in Lua (`hyprland.lua` + `conf/*.lua` + `local/*.lua`). Requires Hyprland >= 0.57, which no longer reads `hyprland.conf`.

There are no build, test, or lint steps — changes take effect by reloading the compositor.

## Applying Changes

```bash
Hyprland --verify-config --config ~/.config/hypr/hyprland.lua  # Check for errors without starting
hyprctl reload                      # Reload hyprland.lua and all required modules
hyprctl configerrors                # Show errors from the running config
hyprctl dispatch 'hl.dsp.exit()'    # dispatch takes a Lua expression (hl.dsp.*)
```

Scripts in `scripts/` are plain shell scripts with no dependencies to install.

## Architecture

`hyprland.lua` is the entry point. It loads the modules in `conf/` with `require("conf.<name>")`, then every `local/*.lua` (machine-local overrides, alphabetical, loaded last).

`conf/settings.lua` and `conf/colors.lua` return tables; other modules use them with `local s = require("conf.settings")` / `local c = require("conf.colors")`.

### Key Settings (conf/settings.lua)

- `s.mod` — modifier key (SUPER)
- `s.terminal` — `foot`
- `s.editor` — chains `fzf` (project selection from `~/projects/git`) → `nvim` in the terminal
- `s.browser`, `s.menu`, `s.todo`, `s.screenlock` — application/script shortcuts

### Modular Config Responsibilities

| File | Purpose |
|------|---------|
| `conf/keybindings.lua` | All keyboard/mouse shortcuts; every bind has a `description` (shown by `scripts/keybindings.sh`) |
| `conf/window.lua` | Border colors, gaps, and window rules (sizes are expressions, e.g. `monitor_w*0.8 monitor_h*0.8`) |
| `conf/autostart.lua` | Programs launched on `hyprland.start` |
| `conf/input.lua` | Keyboard (US/NO layouts, caps→esc), mouse, touchpad |
| `conf/monitor.lua` | Display resolution and positioning |
| `conf/environment.lua` | Env vars (Wayland flags, NVIDIA, cursor size) |
| `conf/misc.lua` | One-off Hyprland toggles |
| `conf/animation.lua`, `conf/decoration.lua`, `conf/cursor.lua`, `conf/layout.lua` | Look and feel, master layout |

### Scripts

- `scripts/power_menu.sh` — `wofi` menu for lock/logout/suspend/reboot/shutdown
- `scripts/keybindings.sh` — fzf list of binds from `hyprctl binds -j` (binding + description)
- `scripts/hyprlock_battery_status.sh` — outputs battery string for `hyprlock` display (returns empty on desktop)

### Lock Screen & Idle

- `hypridle.conf` — locks at 3 min idle, turns off displays at 4 min; suspend is commented out (NVIDIA incompatibility)
- `hyprlock.conf` — Nord-themed lock screen; battery status is refreshed every 5 seconds via `hyprlock_battery_status.sh`

hyprpaper, hyprlock and hypridle still use the hyprlang (`.conf`) format. `hyprpaper.conf` picks a random wallpaper from `~/.local/share/backgrounds/wallpapers/nord/` at startup.

## Color Theme

Nord palette is used consistently throughout (`conf/colors.lua`). Key values:
- Background: `#2e3440` / `#3b4252`
- Foreground/text: `#eceff4`
- Accent (borders): `rgb(88c0d0)` → `rgb(4c566a)` gradient at 45°
- Shadow: `0xee1a1a1a`

## Window Rules

Defined in `conf/window.lua`. Currently floating: `btop`, `nnn`, `todo`, `keybindings` (foot titles), Volume Control, file dialogs, update windows, VNC, FortiClient. QEMU and virt-viewer windows go to workspace 4, Slack to workspace 3.
