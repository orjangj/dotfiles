#!/bin/bash
 
entries="Lock Logout Suspend Reboot Shutdown"
 
selected=$(printf '%s\n' $entries | wofi --show dmenu --insensitive | awk '{print tolower($1)}')
 
case $selected in
	lock)
        swaylock -f ;;
	logout)
        swaymsg exit ;;
	suspend)
        systemctl suspend ;;
	reboot)
        systemctl reboot ;;
	shutdown)
        systemctl poweroff ;;
esac
