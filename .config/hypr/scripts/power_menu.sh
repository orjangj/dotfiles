#!/bin/bash

entries=" Lock\n⇠ Logout\n⏾ Suspend\n Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | wofi -p "Power Menu" --width 270 --height 270 --dmenu --cache-file /dev/null --insensitive | awk '{print tolower($2)}')

case $selected in
  lock)
    exec $HOME/.config/hypr/scripts/locker.sh ;;
  logout)
    hyprctl dispatch exit ;;
  suspend)
    exec systemctl suspend ;;
  reboot)
    exec systemctl reboot ;;
  shutdown)
    exec systemctl poweroff ;;
esac
