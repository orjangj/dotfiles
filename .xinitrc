#!/bin/sh

# TODO: source anything in /etc/X11/xinit/xinitrc.d if it exists?

session=${1:-qtile}

case $session in
    awesome ) exec awesome;;
    qtile   ) exec qtile start;;
    *       ) exec $1;;
esac

