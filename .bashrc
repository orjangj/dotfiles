# vim:ft=bash
#
# ~/.bashrc: executed by bash(1) for non-login shells.
#
# See /usr/share/doc/bash/examples/startup-files (in the package bash-doc) for examples.
#

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# shellcheck disable=SC1090
for f in ~/.config/bash/*.bash; do 
    [ -r "$f" ] && . "$f" 
done

