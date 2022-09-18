# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Non-interactive guard
case $- in
    *i*) ;;
      *) return;;
esac

### History configuration 
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Prompt configuration
USERNAME="\u"
HOSTNAME="\h"
WORKDIR="\W"
RESET="\[\033[0m"
RED="\[\033[00;31m\]"
RED_BOLD="\[\033[01;31m\]"
GREEN="\[\033[00;32m\]"
GREEN_BOLD="\[\033[01;32m\]"
YELLOW="\[\033[00;33m\]"
YELLOW_BOLD="\[\033[01;33m\]"
BLUE="\[\033[00;34m\]"
BLUE_BOLD="\[\033[01;34m\]"
WHITE="\[\033[00;37m\]"
WHITE_BOLD="\[\033[01;37m\]"

#parse_git_branch() {
#    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
#}

git_prompt() {
    # Check if we're inside a git repository
    if git status 1> /dev/null 2> /dev/null ; then
        # Either we get the current branch name, the tag name, or the short commit hash
        branch=$(git symbolic-ref -q --short HEAD \
            || git describe --tags --exact-match 2>/dev/null \
            || git rev-parse --short HEAD
        )

        # Check symbolic ref again to make sure we're detached or not
        if git symbolic-ref -q HEAD 1>/dev/null; then
            detached=false
        else
            detached=true
        fi

        staged=$(git diff --staged --name-status | wc -l)
        changed=$(git diff --name-status | wc -l)
        untracked=$(git ls-files --others --exclude-standard | wc -l)
        conflicts=$(git diff --name-only --diff-filter=U --relative | wc -l)
        ahead=$(git rev-list $branch --not origin/$branch 2>/dev/null | wc -l)
        diverged=$(git rev-list origin/$branch --not $branch 2>/dev/null | wc -l)

        # Build the git prompt
        prompt="($branch"
        if [ "$detached" = true ] ; then
            prompt="$prompt|detached|"
        else
            prompt="$prompt|↑$ahead↓$diverged|"
        fi

        if [[ $staged -ne 0 || $changed -ne 0 || $untracked -ne 0 || $conflicts -ne 0 ]]; then
            prompt="$prompt+$changed-$untracked∙$staged✠$conflicts"
        else
            prompt="$prompt✓"
        fi

        prompt="$prompt)"
        echo $prompt
    fi
}


PS1="${GREEN_BOLD}┌ ${USERNAME}@${HOSTNAME}${BLUE_BOLD} ➜ ${WORKDIR} ${YELLOW_BOLD}\$(git_prompt)\n${GREEN_BOLD}└┄ ${RESET}"
PS2="${YELLOW_BOLD}➜ ${RESET}"

# Source aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
# Any alias that is not part of source control.
# This file should mostly include aliases that are relevant in the short term,
# but not important for source control. Such as work/project related aliases.
if [ -f ~/.bash_aliases_extras ]; then
    . ~/.bash_aliases_extras
fi

# Source functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
# Any function that is not part of source control.
# This file should mostly include functions that are relevant in the short term,
# but not important for source control. Such as work/project related functions.
if [ -f ~/.bash_functions_extras ]; then
    . ~/.bash_aliases_extras
fi

# Source programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add paths
path_prepend() {
    # Only adds path if it exists and isn't already included in PATH
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

path_append() {
    # Only adds path if it exists and isn't already included in PATH
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

path_prepend ~/.local/bin
path_prepend ~/bin

# Environment variables
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export SSL_CERT_DIR=/etc/ssl/certs

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob '!.git''
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if type nvim &> /dev/null; then
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

# NOTE: This is really slow if printing GPU information
#if type neofetch &> /dev/null; then
#    neofetch
#fi

