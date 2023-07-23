# vim:ft=bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# General
# -----------------------------------------------------------------------------

shopt -s checkwinsize
shopt -s histappend

set -o noclobber

if [[ -n $SSH_CONNECTION ]]; then
    export VISUAL=vim
elif type nvim &> /dev/null; then
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

# Configure less:
#   F: automatically exit if the entire file can be displayed in first screen.
#   I: case-insensitive search.
#   R: Show ANSI colors.
#   S: Truncate long lines.
#   X: Prevent clearing the screen when exiting.
export LESS="FIRSX"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# History
# -----------------------------------------------------------------------------

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1024
HISTFILESIZE=2048

# Colors
# -----------------------------------------------------------------------------

# Enable color support for ls
if [ -x /usr/bin/dircolors ]; then
    test -r "$HOME"/.dircolors && eval "$(dircolors -b "$HOME"/.dircolors)" || eval "$(dircolors -b)"
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Prompt
# -----------------------------------------------------------------------------

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
MAGENTA="\[\033[00;35m\]"
MAGENTA_BOLD="\[\033[01;35m\]"
CYAN="\[\033[00;36m\]"
CYAN_BOLD="\[\033[01;36m\]"
WHITE="\[\033[00;97m\]"
WHITE_BOLD="\[\033[01;97m\]"

export VIRTUAL_ENV_DISABLE_PROMPT=1

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
        prompt="(:$branch"
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

virtual_prompt() {
    local prompt=""
    local venv
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then
        venv=$(basename "$VIRTUAL_ENV")
        prompt="(:${venv})"
    fi
    echo $prompt
}

PS1="${GREEN_BOLD}┌  \u"
PS1="${PS1} ${CYAN_BOLD} \h"
PS1="${PS1} ${BLUE_BOLD} ${WORKDIR}"
PS1="${PS1} ${YELLOW_BOLD}\$(git_prompt)"
PS1="${PS1} ${MAGENTA_BOLD}\$(virtual_prompt)"
PS1="${PS1}\n${GREEN_BOLD}└┄ ${RESET}"

PS2="${YELLOW_BOLD}➜ ${RESET}"

# Includes
# -----------------------------------------------------------------------------

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Completion
# -----------------------------------------------------------------------------

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Path
# -----------------------------------------------------------------------------

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
path_prepend ~/go/bin
path_prepend ~/.cargo/bin
path_prepend ~/node_modules/.bin

# Various
# -----------------------------------------------------------------------------

#export SSL_CERT_DIR=/etc/ssl/certs

# Integrations
# -----------------------------------------------------------------------------

export VAGRANT_DEFAULT_PROVIDER="libvirt"

if type fzf &> /dev/null; then
  if type fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
  elif type rg &> /dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!{.git,node_modules,venv}/*" 2> /dev/null'
  fi

  export FZF_DEFAULT_OPTS='-m --height 50% --border --color=16'

  if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    . /usr/share/fzf/shell/key-bindings.bash
  elif [ -f /usr/share/fzf/key-bindings.bash ]; then
    . /usr/share/fzf/key-bindings.bash
  fi

  export FZF_CTRL_T_OPTS="--select-1 --exit-0 --preview '(bat {} || tree -C {}) 2> /dev/null | head -200'"
  export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
  export FZF_ALT_C_OPTS="--select-1 --exit-0 --preview 'tree -C {} | head -200'"
fi

if type nnn &> /dev/null; then
  export NNN_OPTS="HP"
  export NNN_FCOLORS="0B0B04060006060009060B06"
  export NNN_FIFO="/tmp/nnn.fifo"
  export NNN_PLUG="p:preview-tui;d:fzcd"
  export NNN_SPLIT="v"
fi
