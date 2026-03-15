shopt -s checkwinsize
shopt -s histappend

set -o noclobber

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
