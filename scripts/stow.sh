#!/usr/bin/env bash
set -euo pipefail

# DOTFILES_DIR="$HOME/dotfiles"

declare -A CONFIGS
parse_kv_file "$DEPS_DIR/stow.txt" CONFIGS

info "Changing directory to dotfiles repository: $DOTFILES_DIR."
cd "$DOTFILES_DIR" || { error "Dotfiles directory not found!"; exit 1; }

info "Stowing dotfiles..."
for cfg in "${!CONFIGS[@]}"; do

  TARGET_DIR=$(eval echo "${CONFIGS[$cfg]}")

  if [[ -d "$cfg" ]]; then
    if [[ "$TARGET_DIR" == /usr/* || "$TARGET_DIR" == /etc/* ]]; then
      info "Stowing $cfg to $TARGET_DIR (sudo)..."
      sudo stow -v -t "$TARGET_DIR" "$cfg"
    else
      info "Stowing $cfg to $TARGET_DIR..."
      stow -v -t "$TARGET_DIR" "$cfg"
    fi
  else
    warn "Config '$cfg' not found — skipping."
  fi

done

success "All configurations stowed successfully."

