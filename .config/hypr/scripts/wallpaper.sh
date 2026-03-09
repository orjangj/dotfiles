#!/bin/bash

# Wait for hyprpaper IPC to be ready (up to 10s)
for _ in $(seq 1 20); do
    hyprctl hyprpaper listloaded &>/dev/null && break
    sleep 0.5
done

wallpaper="$(find ~/.local/share/backgrounds/wallpapers/nord/ -type f | shuf -n 1)"
hyprctl hyprpaper unload all
hyprctl hyprpaper preload "$wallpaper"
hyprctl hyprpaper wallpaper ",$wallpaper"
