#!/bin/bash
# Dependencies: imagemagick, grim

# Need these to capture multiple monitors' screenshots
declare -a outputs
declare -a images

poutputs=$(hyprctl monitors -j | jq -r '.[] | select(.dpmsStatus != false) | .name')
while read -r line; do
    outputs+=($line)
    images+=("/tmp/${line}.png")
done <<< "$poutputs"

arraylen=${#outputs[@]}
for (( i=0; i<${arraylen}; i++ ));
do
  command -- "grim" -o "${outputs[$i]}" "${images[$i]}"

  # TODO: annotate with icon and text
  convert -scale 5% "${images[$i]}" "${images[$i]}"

  param+=("-i" "${outputs[$i]}:${images[$i]}" "-K")
done

if ! swaylock "${param[@]}" >/dev/null 2>&1; then
    # We have failed, lets get back to stock behavior
    swaylock
fi
