# Add a directory to the beginning of PATH.
# Skips if the directory doesn't exist or is already in PATH.
# Usage: path_prepend ~/bin
path_prepend() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

# Add a directory to the end of PATH.
# Skips if the directory doesn't exist or is already in PATH.
# Usage: path_append /opt/tools/bin
path_append() {
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

if [[ -n $SSH_CONNECTION ]]; then
    export VISUAL=vim
elif type nvim &> /dev/null; then
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

export LESS="FIRSX"

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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
