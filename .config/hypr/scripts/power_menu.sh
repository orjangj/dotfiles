#!/bin/bash

source "$(dirname "$0")/hypr_version.sh"

entries=" Lock\n⇠ Logout\n⏾ Suspend\n Reboot\n⏻ Shutdown"

selected=$(echo -e "$entries" | wofi -p "Power Menu" --width 270 --height 270 --dmenu --cache-file /dev/null --insensitive | awk '{print tolower($2)}')

case $selected in
  lock)
    hyprlock ;;
  logout)
    # Hyprland >= 0.57: dispatch takes a Lua expression
    if hypr_version_ge 0.57; then
      hyprctl dispatch 'hl.dsp.exit()'
    else
      hyprctl dispatch exit
    fi ;;
  suspend)
    exec systemctl suspend ;;
  reboot)
    exec systemctl reboot ;;
  shutdown)
    exec systemctl poweroff ;;
esac
