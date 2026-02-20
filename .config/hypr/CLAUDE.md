# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Hyprland (Wayland compositor) configuration. There are no build, test, or lint steps — changes take effect by reloading the compositor.

## Applying Changes

```bash
hyprctl reload          # Reload hyprland.conf and all sourced configs
hyprctl dispatch <cmd>  # Run a one-off dispatcher command
```

Scripts in `scripts/` are plain shell scripts with no dependencies to install.

## Architecture

`hyprland.conf` is the entry point and sources all files under `conf/` in order. **`conf/settings.conf` must be sourced first** — it defines variables (`$MOD`, `$TERMINAL`, `$BROWSER`, `$EDITOR`, `$STATUSBAR`, etc.) that the other config files reference.

### Key Variable Definitions (conf/settings.conf)

- `$MOD` — modifier key (SUPER)
- `$TERMINAL` — `foot`
- `$EDITOR` — chains `fzf` (project selection from `~/projects`) → `nvim` in the terminal
- `$BROWSER`, `$MENU`, `$TODO`, `$LOCK`, `$WALLPAPER` — application/script shortcuts

### Modular Config Responsibilities

| File | Purpose |
|------|---------|
| `conf/keybindings.conf` | All keyboard/mouse shortcuts |
| `conf/window.conf` | Border colors, gaps, and floating window rules |
| `conf/autostart.conf` | Programs launched at session start |
| `conf/input.conf` | Keyboard (US/NO layouts, caps→esc), mouse, touchpad |
| `conf/monitor.conf` | Display resolution and positioning |
| `conf/workspace.conf` | Workspace definitions |
| `conf/environment.conf` | Env vars (Wayland flags, NVIDIA, cursor size) |
| `conf/misc.conf` | One-off Hyprland toggles |

### Scripts

- `scripts/wallpaper.sh` — picks a random wallpaper from `~/.local/share/backgrounds/wallpapers/nord/` via `swaybg`
- `scripts/power_menu.sh` — `wofi` menu for lock/logout/suspend/reboot/shutdown
- `scripts/hyprlock_battery_status.sh` — outputs battery string for `hyprlock` display (returns empty on desktop)

### Lock Screen & Idle

- `hypridle.conf` — locks at 3 min idle, turns off displays at 4 min; suspend is commented out (NVIDIA incompatibility)
- `hyprlock.conf` — Nord-themed lock screen; battery status is refreshed every 5 seconds via `hyprlock_battery_status.sh`

## Color Theme

Nord palette is used consistently throughout. Key values:
- Background: `#2e3440` / `#3b4252`
- Foreground/text: `#eceff4`
- Accent (borders, highlights): `rgb(88c0d0)` → `rgb(a3be8c)` gradient at 45°
- Shadow: `0xff2e3440`

## Floating Window Rules

Defined in `conf/window.conf`. Currently floating: `btop`, `nnn`, `todo` (foot with title "todo"), VNC, VirtualBox, FortiClient. QEMU VMs are pinned to workspace 4.
