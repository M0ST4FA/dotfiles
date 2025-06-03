#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/install_scripts" && pwd)"
source "$SCRIPT_DIR/utils.sh"

info "Starting installation..."

source "$SCRIPT_DIR/deps.sh"
source "$SCRIPT_DIR/stow.sh"

success "✅ All done!"

