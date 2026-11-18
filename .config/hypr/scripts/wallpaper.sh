#!/bin/bash
# Set a random wallpaper via hyprpaper IPC. Works with hyprpaper 0.7 and 0.8.

source "$(dirname "$0")/hypr_version.sh"

wallpaper="$(find ~/.local/share/backgrounds/wallpapers/nord/ -type f | shuf -n 1)"

if hypr_version_ge 0.57; then
    # hyprpaper 0.8: no preload/unload/listloaded; the wallpaper request loads
    # the image. Retry until hyprpaper's IPC is up (up to 10s at session start).
    for _ in $(seq 1 20); do
        hyprctl hyprpaper wallpaper ",$wallpaper" &>/dev/null && exit 0
        sleep 0.5
    done
    exit 1
fi

# hyprpaper 0.7: wait for IPC, then preload and set
for _ in $(seq 1 20); do
    hyprctl hyprpaper listloaded &>/dev/null && break
    sleep 0.5
done

hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$wallpaper"
hyprctl hyprpaper wallpaper ",$wallpaper"
