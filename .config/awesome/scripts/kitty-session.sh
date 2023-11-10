#!/bin/bash

projects="${HOME}/projects/git"
selected=$(ls ${projects} | rofi -p "Projects" -dmenu -sort -i -no-fixed-num-lines -no-show-icons | awk '{print tolower($1)}')

export MY_KITTY_SESSION_PROJECT_DIR=${projects}/${selected}

kitty --session ${HOME}/.config/awesome/scripts/kitty-session.conf

