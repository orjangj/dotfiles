#!/bin/bash
# List binds with fzf. Lua binds (Hyprland >= 0.57) carry a description and an
# opaque dispatcher/arg (e.g. "HL.Dispatcher(exec_cmd)", "7"); hyprlang binds
# usually have no description, so fall back to "dispatcher arg".

hyprctl binds -j | jq -r '
.[] |
select(.catch_all == false) |
(
  (if (.modmask / 64 | floor) % 2 == 1 then "SUPER+" else "" end) +
  (if (.modmask / 1  | floor) % 2 == 1 then "SHIFT+" else "" end) +
  (if (.modmask / 4  | floor) % 2 == 1 then "CTRL+"  else "" end) +
  (if (.modmask / 8  | floor) % 2 == 1 then "ALT+"   else "" end) +
  (.key | ascii_upcase)
) as $binding |
(if (.description // "") != "" then .description else "\(.dispatcher) \(.arg)" end) as $action |
"\($binding)\t\($action)"
' | column -t -s $'\t' | \
  fzf --no-sort --layout reverse --height 100% \
      --color=16 \
      --prompt "  " \
      --header "BINDING                          ACTION" \
      --bind "esc:abort"
