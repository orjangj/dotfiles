-- Programs and commands referenced by other modules: local s = require("conf.settings")
local s = {}

s.mod        = "SUPER"

s.shell      = "bash"
s.terminal   = "foot"
s.browser    = "xdg-open https://"
s.statusbar  = "waybar"
s.menu       = "wofi --show drun"
s.screenshot = [[grim -g "$(slurp)" - | swappy -f -]]
s.screenlock = "hyprlock"

s.editor     = s.terminal .. [[ --title nvim -- ]] .. s.shell .. [[ -i -c "cd ~/projects/git; cd \$(ls | fzf --no-height --reverse --select-1 --exit-0 --preview 'tree -C {} | head -200'); nvim"]]
s.filemngr   = s.terminal .. [[ --title nnn -- ]] .. s.shell .. [[ -i -c "nnn -P 'p'"]]
s.todo       = s.terminal .. [[ --title todo -- ]] .. s.shell .. [[ -i -c "nvim -c ':cd ~/notes' -c ':edit ~/notes/todo.md'"]]
s.btop       = s.terminal .. [[ --title btop -- ]] .. s.shell .. [[ -i -c "btop"]]
s.hyprconfig = s.terminal .. [[ --title hyprcfg -- ]] .. s.shell .. [[ -i -c "cd ~/.config/hypr; nvim"]]

s.statusbar_toggle = "killall -SIGUSR1 " .. s.statusbar

s.keybindings = s.terminal .. [[ --title keybindings -- bash -c "$HOME/.config/hypr/scripts/keybindings.sh"]]
s.power_menu  = "$HOME/.config/hypr/scripts/power_menu.sh"
s.wallpaper   = "$HOME/.config/hypr/scripts/wallpaper.sh"

return s
