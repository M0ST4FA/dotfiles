#!/bin/bash

# Get the current brightness percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
percent=$(( 100 * brightness / max_brightness ))

# Choose icon
if [ "$percent" -lt 30 ]; then
    icon="🔅"
elif [ "$percent" -lt 70 ]; then
    icon="🔆"
else
    icon="🌞"
fi

# Send notification
notify-send -t 1500 "$icon Brightness: $percent%"

