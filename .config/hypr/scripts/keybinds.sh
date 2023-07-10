#!/bin/bash

keybinds=$(grep -oP '(?<=bind = ).*' $HOME/.config/hypr/hyprland.conf)
keybinds=$(echo "$keybinds" | sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')
wofi --dmenu -p "Keybinds" --insensitive <<< "$keybinds"
