#!/bin/bash

# TODO: Support suspend and hibernate?
entries=(lockscreen logout reboot shutdown)

declare -A texts
texts[lockscreen]="Lock"
texts[logout]="Logout"
texts[reboot]="Reboot"
texts[shutdown]="Shutdown"

declare -A icons
icons[lockscreen]=""
icons[logout]=""
icons[reboot]=""
icons[shutdown]=""

declare -A actions
actions[lockscreen]="i3lock -c 000000"
actions[logout]="qtile cmd-obj -o cmd -f shutdown"
actions[reboot]="systemctl reboot"
actions[shutdown]="systemctl poweroff"

declare -A messages
for entry in "${entries[@]}"
do
  messages[$entry]="${texts[$entry]}\0icon\x1f<span color='white'>${icons[$entry]}</span>"
done

selected=$( IFS=$'\n'; echo -en "${messages[*]}" | rofi -dmenu -show-icons -theme-str 'element-icon { size: 1.0em; }' -p " " | awk '{print tolower($1)}' )

echo "${selected}"

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
