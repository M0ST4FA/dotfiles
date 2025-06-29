#!/bin/bash

ICON_INFO="ℹ️"
ICON_WARN="⚠️"
ICON_ERR="❌"
ICON_OK="✅"

info()    { echo -e "${ICON_INFO} \033[1;34m$1\033[0m"; }
warn()    { echo -e "${ICON_WARN} \033[1;33m$1\033[0m"; }
error()   { echo -e "${ICON_ERR} \033[1;31m$1\033[0m" >&2; }
success() { echo -e "${ICON_OK} \033[1;32m$1\033[0m"; }

read_lines_to_array() {
  local file="$1"
  local -n out_array="$2"   # Use nameref to write to caller's array

  out_array=()

  if [[ ! -f "$file" ]]; then
    error "File not found: $file"
    return 1
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading and trailing whitespace
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"

    # Skip empty lines or comment lines
    [[ -z "$line" || "$line" == \#* ]] && continue

    out_array+=("$line")
  done < "$file"
}

