#!/usr/bin/env bash
set -euo pipefail

# DOTFILES_DIR="$HOME/dotfiles"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/scripts" && pwd)"
DEPS_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")/deps" && pwd)"
DOTFILES_DIR="$(pwd)"
TARGET_DIR="$HOME"
ROOT_TARGET_DIR="/"

source "$SCRIPT_DIR/utils.sh"

CONFIGS=()
read_lines_to_array "$DEPS_DIRECTORY/stow.txt" CONFIGS

info "Changing directory to dotfiles repository: $DOTFILES_DIR."
cd "$DOTFILES_DIR" || { error "Dotfiles directory not found!"; exit 1; }

info "Stowing dotfiles..."
for cfg in "${CONFIGS[@]}"; do

  if [ "$cfg" = "wallpapers" ]; then
    info "Unstowing $cfg..."
    sudo stow -v -D -t "$ROOT_TARGET_DIR" "$cfg"
  elif [ -d "$cfg" ]; then
    info "Unstowing $cfg..."
    stow -v -D -t "$TARGET_DIR" "$cfg"
  else
    warn "Config $cfg not found!"
  fi

done

success "All configurations unstowed successfully."

