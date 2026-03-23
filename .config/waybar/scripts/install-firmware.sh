#!/bin/bash

run_in_terminal() {
    if command -v foot &>/dev/null; then
        foot -T "Firmware Update" bash -c "echo ':: Firmware Update'; echo; fwupdmgr update; echo; read -rp 'Press Enter to close...'"
    elif command -v kitty &>/dev/null; then
        kitty -T "Firmware Update" bash -c "echo ':: Firmware Update'; echo; fwupdmgr update; echo; read -rp 'Press Enter to close...'"
    else
        notify-send -u critical "Firmware" "No supported terminal found (install foot or kitty)"
        exit 1
    fi
}

run_in_terminal

pkill -RTMIN+9 waybar
