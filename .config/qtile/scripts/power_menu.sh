#!/bin/bash

# TODO: Support suspend and hibernate?
entries=(lockscreen logout reboot shutdown)

declare -A texts
texts[lockscreen]="Lock"
texts[logout]="Logout"
texts[reboot]="Reboot"
texts[shutdown]="Shutdown"

declare -A icons
icons[lockscreen]="system-lock-screen-symbolic"
icons[logout]="system-log-out-symbolic"
icons[reboot]="system-reboot-symbolic"
icons[shutdown]="system-shutdown-symbolic"

declare -A actions
actions[lockscreen]="i3lock -c 000000"
actions[logout]="qtile cmd-obj -o cmd -f shutdown"
actions[reboot]="systemctl reboot"
actions[shutdown]="systemctl poweroff"


declare -A messages
for entry in "${entries[@]}"
do
  messages[$entry]="${texts[$entry]}\0icon\x1f${icons[$entry]}\n"
done

selected=$(echo -en "${messages[@]}" | tr -d ' ' | rofi -dmenu -show-icons -p System | awk '{print tolower($1)}')

# TODO: Add confirmation on irreversible actions?
case $selected in
	logout)
        qtile cmd-obj -o cmd -f shutdown ;;
	lock)
        i3lock -c 000000 ;;
	reboot)
        systemctl reboot ;;
	shutdown)
        systemctl poweroff ;;
esac
