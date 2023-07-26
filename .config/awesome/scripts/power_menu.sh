#!/bin/bash

entries=" Lock\n⇠ Logout\n⏾ Suspend\n⭮ Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | rofi -p "Power Menu" -dmenu -i | awk '{print tolower($2)}')

case $selected in
  lock)
    i3lock -c 000000 ;;
  logout)
    awesome-client 'awesome.quit()' ;;
  suspend)
    exec systemctl suspend ;;
  reboot)
    exec systemctl reboot ;;
  shutdown)
    exec systemctl poweroff ;;
esac
