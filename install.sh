#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/stow" && pwd)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/scripts" && pwd)"

DEPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/deps" && pwd)"

GIT_INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
GIT_PACKAGES_FILE="$DEPS_DIR/git.txt"

source "$SCRIPT_DIR/utils.sh"

info "Starting installation..."

source "$SCRIPT_DIR/install_deps.sh"
source "$SCRIPT_DIR/stow.sh"

success "All done!"

