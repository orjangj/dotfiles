#!/bin/bash

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
"\($binding)\t\(.dispatcher)\t\(.arg)"
' | column -t -s $'\t' | \
  fzf --no-sort --layout reverse --height 100% \
      --color=16 \
      --prompt "  " \
      --header "BINDING                          ACTION               ARGUMENT" \
      --bind "esc:abort"
