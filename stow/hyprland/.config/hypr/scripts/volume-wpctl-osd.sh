#!/bin/bash

# Helper: Send swaync notification
send_notification() {
    local icon="$1"
    local message="$2"
    notify-send -t 1500 "$icon $message"
}

# Check if mic mute toggle was passed
if [ "$1" == "mic" ]; then
    mic_muted=$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED && echo true || echo false)
    if [ "$mic_muted" = "true" ]; then
        send_notification "🎙️❌" "Microphone Muted"
    else
        send_notification "🎙️✅" "Microphone Unmuted"
    fi
    exit 0
fi

# Get speaker volume and mute status
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

# Consider 0 volume as muted
if [ "$volume" -eq 0 ]; then
    is_muted=true
fi

# Select icon and message
if [ "$is_muted" = "true" ]; then
    icon="🔇"
    message="Muted"
elif [ "$volume" -lt 30 ]; then
    icon="🔈"
    message="Volume: ${volume}%"
elif [ "$volume" -lt 70 ]; then
    icon="🔉"
    message="Volume: ${volume}%"
else
    icon="🔊"
    message="Volume: ${volume}%"
fi

# Show the notification
send_notification "$icon" "$message"

