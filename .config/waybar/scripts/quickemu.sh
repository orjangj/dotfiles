#!/bin/bash

QUICKEMU_DIR="$HOME/.quickemu"

get_vm_name() {
    basename "$1" .conf
}

is_running() {
    local vm="$1"
    local pid_file="$QUICKEMU_DIR/$vm/$vm.pid"
    [[ -f "$pid_file" ]] || return 1
    local pid
    pid=$(cat "$pid_file" 2>/dev/null)
    [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null
}

case "$1" in
    --menu)
        declare -a items
        declare -a actions

        for conf in "$QUICKEMU_DIR"/*.conf; do
            [[ -f "$conf" ]] || continue
            vm=$(get_vm_name "$conf")
            if is_running "$vm"; then
                items+=("■ Stop $vm")
                actions+=("stop:$vm")
            else
                items+=("▶ Start $vm")
                actions+=("start:$vm")
            fi
        done

        [[ ${#items[@]} -eq 0 ]] && { notify-send "Quickemu" "No VMs found"; exit; }

        menu_str=""
        for item in "${items[@]}"; do
            menu_str+="$item\n"
        done

        choice=$(printf "%b" "$menu_str" | wofi --dmenu --prompt "QuickEmu" --insensitive)
        [[ -z "$choice" ]] && exit

        for i in "${!items[@]}"; do
            if [[ "${items[$i]}" == "$choice" ]]; then
                action="${actions[$i]}"
                type="${action%%:*}"
                vm="${action##*:}"
                conf="$QUICKEMU_DIR/$vm.conf"
                case "$type" in
                    start)
                        notify-send "Quickemu" "Starting $vm..."
                        nohup quickemu --vm "$conf" &>/dev/null &
                        ;;
                    stop)
                        pid_file="$QUICKEMU_DIR/$vm/$vm.pid"
                        if [[ -f "$pid_file" ]]; then
                            pid=$(cat "$pid_file" 2>/dev/null)
                            kill "$pid" 2>/dev/null \
                                && notify-send "Quickemu" "Stopping $vm..." \
                                || notify-send -u critical "Quickemu" "Failed to stop $vm"
                        fi
                        ;;
                esac
                break
            fi
        done
        ;;
    *)
        running=0
        total=0
        tooltip=""

        for conf in "$QUICKEMU_DIR"/*.conf; do
            [[ -f "$conf" ]] || continue
            vm=$(get_vm_name "$conf")
            ((total++))
            if is_running "$vm"; then
                ((running++))
                tooltip+="● $vm (running)\\n"
            else
                tooltip+="○ $vm (stopped)\\n"
            fi
        done

        if [[ $total -eq 0 ]]; then
            printf '{"text": "󰢹 -", "tooltip": "No VMs found", "class": "idle"}\n'
            exit
        fi

        tooltip="${tooltip%\\n}"
        class="idle"
        [[ $running -gt 0 ]] && class="running"

        printf '{"text": "󰢹 %d/%d", "tooltip": "%s", "class": "%s"}\n' \
            "$running" "$total" "$tooltip" "$class"
        ;;
esac
