# vim:ft=bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# General {{{

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

# }}}
# History {{{

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1024
HISTFILESIZE=2048

# }}}
# Colors {{{

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

# Enable color support for ls
if [ -x /usr/bin/dircolors ]; then
    test -r "$HOME"/.dircolors && eval "$(dircolors -b "$HOME"/.dircolors)" || eval "$(dircolors -b)"
fi

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# }}}
# Functions {{{
function venv {
    if [[ "$1" == "create" && ! -d "venv" ]]; then
        python -m venv venv

        if [[ -f requirements.txt ]]; then
            ./venv/bin/pip install -r requirements.txt
        fi
    elif [[ "$1" == "destroy" ]]; then
        if [[ ! -z "${VIRTUAL_ENV}" ]]; then
            deactivate
        fi
        rm -rf venv
    fi
}
# }}}
# Prompt {{{

# See https://git-scm.com/docs/git-status
function prompt_git() {
    local prompt=""

    # The 'local' statement needs to be on its own line since it
    # will overwrite $?.
    local git_status=""
    git_status=$(git status --porcelain=v2 --branch --show-stash 2>/dev/null)
    if [[ ! $? -eq 0 ]]; then
        # Not a Git repository (or some error occured).
        eval "$1='${prompt}'"
        return
    fi

    local oid=""
    local branch=""
    local stash=0
    local ahead=0
    local behind=0
    local staged=0
    local changed=0
    local conflicts=0
    local untracked=0

    while IFS= read -r line || [[ -n $line ]]; do
        case "${line:0:1}" in
            '#')
                IFS=' ' read -r -a array <<< "${line:1}"
                if [[ "${array[0]}" == "branch.oid" ]]; then
                    oid="${array[1]}"
                elif [[ "${array[0]}" == "branch.head" ]]; then
                    # if detached, remove '(' and ')' with tr
                    branch=$(echo "${array[1]}" | tr -d "()")
                elif [[ "${array[0]}" == "branch.ab" ]]; then
                    ahead="${array[1]:1}"
                    behind="${array[1]:1}"
                elif [[ "${array[0]}" == "stash" ]]; then
                    stash="${array[1]}"
                fi
                ;;
            '1' | '2')
                if [[ "${line[2]}" == "." ]]; then
                    staged=$((staged+1))
                else
                    changed=$((changed+1))
                fi
                ;;
            'u')
                conflicts=$((conflicts+1))
                ;;
            '?')
                untracked=$((untracked+1))
                ;;
        esac
    done < <(printf '%s' "${git_status}")

    # Build the git prompt
    prompt=":${oid:0:7}"

    if [[ "${branch}" == "detached" ]]; then
        # Check if we're checked out to a tag
        local tag=$(git describe --tags --exact-match 2>/dev/null)
        if [[ ! -z "${tag}" ]]; then
            branch="${branch}:${tag}"
        fi
    fi

    prompt="${prompt}:${branch}"

    local state=""

    if [[ $ahead -ne 0 ]]; then state="${state}:↑$ahead"; fi
    if [[ $behind -ne 0 ]]; then state="${state}:↓$behind"; fi
    if [[ $changed -ne 0 ]]; then state="${state}:✗${changed}"; fi
    if [[ $staged -ne 0 ]]; then state="${state}:${staged}"; fi
    if [[ $untracked -ne 0 ]]; then state="${state}:${untracked}"; fi
    if [[ $conflicts -ne 0 ]]; then state="${state}:${conflicts}"; fi
    if [[ $stash -ne 0 ]]; then state="${state}:${stash}"; fi
    if [[ -z "${state}" ]]; then state=":✓"; fi

    prompt="${prompt}(${state})"
    eval "$1='${prompt}'"
}

# TODO: Not possible to manually deactivate environment if inside path (just gets activated
#       automatically again). Not sure if this is much of a problem as you generally want
#       to use the venv. See custom venv function (above) for management of venv's.
function prompt_python_venv {
    local prompt=""

    # Auto enable/disable python venv
    if [[ -z "${VIRTUAL_ENV}" ]]; then
        # TODO: Implement look-behind to see if parent directories have a venv (and activate top most venv instead)
        if [[ -f $PWD/venv/pyvenv.cfg ]]; then
            . $PWD/venv/bin/activate
        fi
    else
        local parentdir="$(dirname "$VIRTUAL_ENV")"

        # A venv is already active, should we deactivate it?
        if [[ "$PWD"/ != "$parentdir"/* ]] ; then
            # Current working directory is not a subdir of venv parent directory
            deactivate

            # Should we activate the venv for the current working directory?
            if [[ -f $PWD/venv/pyvenv.cfg ]]; then
                . $PWD/venv/bin/activate  # Doesnt seem to work?
            fi
        fi
    fi

    # The prompt
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then
        local name=$(basename $(dirname "$VIRTUAL_ENV"))
        prompt="${prompt}${MAGENTA_BOLD}:${name}${RESET} "
    fi

    eval "$1='${prompt}'"
}

function prompt_command {
    prompt="${GREEN_BOLD}┌  \u"
    prompt="${prompt} ${CYAN_BOLD} \h"
    prompt="${prompt} ${BLUE_BOLD} \W${RESET} "

    prompt_git output
    prompt="${prompt}${YELLOW_BOLD}${output}${RESET}"

    prompt_python_venv output
    prompt="${prompt} ${MAGENTA_BOLD}${output}${RESET}"

    prompt="${prompt}\n${GREEN_BOLD}└┄ ${RESET}"

    export PS1="${prompt}"
    export PS2="${YELLOW_BOLD}➜${RESET} "
}

export PROMPT_COMMAND=prompt_command

# }}}
# Includes {{{

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [ -f ~/.bash_exports ]; then
    . ~/.bash_exports
fi

# }}}
# Completion {{{

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# }}}
# Path {{{

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
path_prepend /snap/bin

# }}}
# Integrations {{{

export CMAKE_GENERATOR=Ninja
export CTEST_OUTPUT_ON_FAILURE=1
export VAGRANT_DEFAULT_PROVIDER="libvirt"
export CPM_SOURCE_CACHE=$HOME/.cache/CPM

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

# }}}
