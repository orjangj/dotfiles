function config() {
    if [ "$1" == "edit" ]; then
        command $EDITOR $HOME/$2
    else
        /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
    fi
}

# vim: set ft=bash:
