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

check_updates() {
    local distro
    distro=$(get_distro)

    case "$distro" in
        fedora)
            dnf check-upgrade --quiet 2>/dev/null | grep -cE '^[a-zA-Z0-9]'
            ;;
        arch|endeavouros|manjaro)
            checkupdates 2>/dev/null | wc -l
            ;;
        ubuntu|debian|pop|linuxmint)
            apt list --upgradable 2>/dev/null | grep -c upgradable
            ;;
        opensuse*|sles)
            zypper list-updates 2>/dev/null | grep -c '^v '
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

list_updates() {
    local distro
    distro=$(get_distro)

    case "$distro" in
        fedora)
            dnf check-upgrade --quiet 2>/dev/null | grep -E '^[a-zA-Z0-9]' | awk '{print $1}'
            ;;
        arch|endeavouros|manjaro)
            checkupdates 2>/dev/null
            ;;
        ubuntu|debian|pop|linuxmint)
            apt list --upgradable 2>/dev/null | grep upgradable | cut -d/ -f1
            ;;
        opensuse*|sles)
            zypper list-updates 2>/dev/null | grep '^v ' | awk -F'|' '{print $3}' | xargs
            ;;
        *)
            echo "Unsupported distro ($(get_distro_name))"
            ;;
    esac
}

printf '{"text": " ...", "tooltip": "Checking for updates", "class": "checking"}\n'

count=$(check_updates)

if [[ "$count" == "unsupported" ]]; then
    printf '{"text": " ?", "tooltip": "Unsupported distro (%s)", "class": "unsupported"}\n' \
        "$(get_distro_name)"
    exit
fi

if [[ "$count" -eq 0 ]]; then
    printf '{"text": " ✓", "tooltip": "System is up to date", "class": "up-to-date", "alt": "up-to-date"}\n'
    exit
fi

tooltip=$(list_updates | head -25)
if [[ "$count" -gt 25 ]]; then
    tooltip+="\\n... and $((count - 25)) more"
fi
tooltip="${tooltip//$'\n'/\\n}"

printf '{"text": " %d", "tooltip": "%s", "class": "updates-available", "alt": "updates-available"}\n' \
    "$count" "$tooltip"

