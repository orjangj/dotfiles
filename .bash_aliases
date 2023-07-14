# vim:ft=bash

# General
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -I'
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'
alias v='nvim'
alias docs='cd ~/Documents'
alias dls='cd ~/Downloads'
alias wallpapers='cd ~/.local/share/backgrounds/wallpapers'
alias configs='cd ~/.config'
alias repos='cd ~/projects/git'

# Workarounds for older machines where terminfo or termcap for xterm-kitty or
# xterm-alacritty are not available
alias ssh="TERM=xterm-256color $(which ssh)"

# Nice to have aliases
alias open=xdg-open
alias resource='. ~/.bash_profile'
alias reload='exec $SHELL -l'

# This need some more customization (not sure what I want yet)
#alias du="du -S | sort -n -r | less -F"
alias df='df -h'

# Navigation aliases
# -----------------------------------------------------------------------------

alias cdl='cd -'
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'
alias .....='cd ..; cd ..; cd ..; cd ..'
alias .4='cd ..; cd ..; cd ..; cd ..'
alias .5='cd ..; cd ..; cd ..; cd ..; cd ..'

# Time
# -----------------------------------------------------------------------------

alias now='date +"%Y-%m-%dT%H:%M:%S"'
alias unow='date -u +"%Y-%m-%dT%H:%M:%S"'
alias nowdate='date +"%Y-%m-%d"'
alias unowdate='date -u +"%Y-%m-%d"'
alias nowtime='date +"%T"'
alias unowtime='date -u +"%T"'
alias timestamp='date -u +%s'
alias week='date +"%Y-W%V"'
alias weekday='date +"%u"'

# Networking
# -----------------------------------------------------------------------------

alias ping='ping -c 5'
alias fastping='ping -c 20 -i.2'

alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias localip="ip route get 1 | sed 's/^.*src \([^ ]*\).*$/\1/;q'"
alias publicip='curl https://ipinfo.io/ip'

# Sysadmin
# -----------------------------------------------------------------------------

alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | grep -E ^/dev/ | sort"
alias path='echo -e ${PATH//:/\\n}'

# Git
# -----------------------------------------------------------------------------

alias gst='git status'
alias gd='git diff'
alias gcb='git checkout -b'
alias gp='git push'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsu='git submodule update'
alias gsuir='git submodule update --init --recursive'
alias lg='lazygit'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Other
# -----------------------------------------------------------------------------

if type colordiff &> /dev/null; then
  alias diff='colordiff'
fi
if type dir &> /dev/null; then
  alias dir='dir --color=auto'
fi
if type vdir &> /dev/null; then
  alias vdir='vdir --color=auto'
fi
