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

function install_system_packages() {
  info "Updating system package database and upgrading..."
  sudo pacman -Syu --noconfirm

  SYSTEM_PACKAGES=()
  read_lines_to_array "$DEPS_DIR/arch.txt" SYSTEM_PACKAGES

  info "Installing system packages..."
  for pkg in "${SYSTEM_PACKAGES[@]}"; do
    if check_package_exists $pkg; then
      info "$pkg already installed."
    else
      info "Instaling $pkg..."
      install_package "$pkg"
    fi
  done
}

function install_npm_packages() {
  NPM_PACKAGES=()
  read_lines_to_array "$DEPS_DIR/npm.txt" NPM_PACKAGES

  info "Installing npm global packages..."
  for npkg in "${NPM_PACKAGES[@]}"; do
    info "Installing $npkg via npm..."
    sudo npm install -g "$npkg"
  done
}

#--------------------------------------
# Core Logic
#--------------------------------------

check_and_install_paru
update_git_submodules
install_system_packages
install_npm_packages

success "All dependencies installed successfully."

