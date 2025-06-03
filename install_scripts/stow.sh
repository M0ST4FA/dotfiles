#!/usr/bin/env bash
set -euo pipefail

# DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="$HOME"

CONFIGS=(
  zsh
  nvim
  git
  hyprland

  wezterm
  kitty
)

info "Changing directory to dotfiles repository: $DOTFILES_DIR"
cd "$DOTFILES_DIR" || { error "Dotfiles directory not found!"; exit 1; }

info "Stowing dotfiles..."
for cfg in "${CONFIGS[@]}"; do

  if [ -d "$cfg" ]; then
    info "Stowing $cfg..."
    stow -v -t "$TARGET_DIR" "$cfg"
  else
    warn "Config $cfg not found!"
  fi

done

success "All configurations stowed successfully."

