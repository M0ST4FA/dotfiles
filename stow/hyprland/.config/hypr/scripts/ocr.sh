#!/bin/bash

set -euo pipefail

region=$(slurp \
	-b "#00000088" \
	-c "#88C0D0FF" \
	-s "#00000000" \
	-w 2
) || exit 1

text=$(grim -g "$region" - | tesseract stdin stdout 2>/dev/null)

[[ $? -ne 0 ]] && exit 1

if [[ -z "$text" ]]; then
	notify-send "OCR failed" "No text detected"
	exit 1
fi

printf "%s" "$text" | wl-copy
notify-send "OCR copied" "$(echo $text | head -c 50)"
paplay /usr/share/sounds/freedesktop/stereo/complete.oga
