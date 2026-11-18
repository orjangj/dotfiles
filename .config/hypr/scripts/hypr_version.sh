#!/bin/bash
# Source from other scripts: hypr_version_ge 0.57 && echo "Lua-era Hyprland"
# Compares the running Hyprland version (hyprctl version -j .tag, e.g. "v0.57.2").
# hyprpaper/hyprlock/hypridle are upgraded together with Hyprland, so the
# Hyprland version also tells which hyprpaper IPC to use.

hypr_version() {
    hyprctl version -j 2>/dev/null | jq -r '.tag // empty' | sed 's/^v//; s/-.*//'
}

# True if the running Hyprland version is >= $1
hypr_version_ge() {
    local current
    current="$(hypr_version)"
    [ -n "$current" ] || return 1
    [ "$(printf '%s\n%s\n' "$1" "$current" | sort -V | head -n1)" = "$1" ]
}
