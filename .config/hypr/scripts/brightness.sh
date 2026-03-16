#!/bin/bash

# Get current brightness percentage
current=$(brightnessctl get)
max=$(brightnessctl max)
percent=$((current * 100 / max))

case "$1" in
    up)
        brightnessctl set 5%+
        ;;
    down)
        if [ "$percent" -le 5 ]; then
            brightnessctl set 1%-
        else
            brightnessctl set 5%-
        fi
        ;;
esac
