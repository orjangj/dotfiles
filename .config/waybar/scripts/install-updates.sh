#!/bin/bash

get_distro() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "$ID"
    else
        echo "unknown"
    fi
}

get_distro_name() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "${PRETTY_NAME:-$ID}"
    else
        echo "unknown"
    fi
}

distro=$(get_distro)

case "$distro" in
    fedora)
        cmd="sudo dnf upgrade"
        ;;
    arch|endeavouros|manjaro)
        cmd="sudo pacman -Syu"
        ;;
    ubuntu|debian|pop|linuxmint)
        cmd="sudo apt update && sudo apt upgrade"
        ;;
    opensuse*|sles)
        cmd="sudo zypper update"
        ;;
    *)
        notify-send -u critical "Updates" "Unsupported distro ($(get_distro_name))"
        exit 1
        ;;
esac

run_in_terminal() {
    if command -v foot &>/dev/null; then
        foot -T "System Update" bash -c "echo ':: System Update'; echo 'Running: $1'; echo; $1; echo; read -rp 'Press Enter to close...'"
    elif command -v kitty &>/dev/null; then
        kitty -T "System Update" bash -c "echo ':: System Update'; echo 'Running: $1'; echo; $1; echo; read -rp 'Press Enter to close...'"
    else
        notify-send -u critical "Updates" "No supported terminal found (install foot or kitty)"
        exit 1
    fi
}

run_in_terminal "$cmd"

pkill -RTMIN+8 waybar
