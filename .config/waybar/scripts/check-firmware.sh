#!/bin/bash

printf '{"text": "󰘚 ...", "tooltip": "Checking firmware updates", "class": "checking"}\n'

fwupdmgr refresh --force &>/dev/null

updates=$(fwupdmgr get-updates 2>/dev/null)
exit_code=$?

if [[ $exit_code -eq 2 ]]; then
    printf '{"text": "󰘚 ✓", "tooltip": "Firmware is up to date", "class": "up-to-date"}\n'
    exit
fi

if [[ $exit_code -ne 0 ]]; then
    printf '{"text": "󰘚 ?", "tooltip": "Could not check firmware updates", "class": "unsupported"}\n'
    exit
fi

count=$(echo "$updates" | grep -c 'New version')
tooltip=$(echo "$updates" | grep -E '(New version|^\S)' | head -20)
tooltip="${tooltip//$'\n'/\\n}"

printf '{"text": "󰘚 %d", "tooltip": "%s", "class": "updates-available"}\n' \
    "$count" "$tooltip"
