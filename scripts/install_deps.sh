#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------
# Function and Variable Declarations
# -------------------------------------

PKG_MANAGER="paru -S --noconfirm"

function install_package() {
  $PKG_MANAGER "$1" && success "Installed $pkg." || error "Failed to install $pkg."
}
function check_package_exists() {
  pacman -Q "$1" &> /dev/null
}

function check_and_install_paru() {
  # Install paru if not present
  info "Checking whether paru exists or not..."
  if ! check_package_exists paru; then
    info "Installing package paru..."
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git ~/paru
    cd ~/paru
    makepkg -si
    rm -rf ~/paru
    cd -1
    success "Installed paru."
  else
    success "paru is already installed."
  fi
}

function update_git_submodules() {
  info "Updating git submodules..."
  git submodule update --init --recursive
  success "Submodules updated."
}

#--------------------------------------
# Core Logic
#--------------------------------------

check_and_install_paru
update_git_submodules
source "$SCRIPT_DIR/install_system_packages.sh"
source "$SCRIPT_DIR/install_git_packages.sh"
source "$SCRIPT_DIR/install_npm_packages.sh"

success "All dependencies installed successfully."

