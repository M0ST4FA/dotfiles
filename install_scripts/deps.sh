#!/usr/bin/env bash
set -euo pipefail

PKG_MANAGER="paru -S --noconfirm"

function install_package() {
  $PKG_MANAGER "$1" && success "Installed $pkg" || error "Failed to install $pkg"
}
function check_package_exists() {
  paru -Q "$1" &> /dev/null
}

# Define system packages needed
SYSTEM_PACKAGES=(
  git
  lazygit
  stow

  nvim

  base-devel

  gcc
  clang

  npm
  nodejs

  glow

  wl-clipboard

  wezterm
  kitty
  foot

  archlinux-wallpaper
)

# Define npm global packages needed
NPM_PACKAGES=(
  bash-language-server
  typescript
  typescript-language-server
)

info "Updating git submodules..."
git submodule update --init --recursive
success "Submodules updated."

info "Updating system package database and upgrading..."
sudo pacman -Syu --noconfirm

info "Installing system packages..."
for pkg in "${SYSTEM_PACKAGES[@]}"; do
  if check_package_exists $pkg; then
    info "$pkg already installed."
  else
    info "Instaling $pkg..."
    install_package "$pkg"
  fi
done

info "Installing npm global packages..."
for npkg in "${NPM_PACKAGES[@]}"; do
  info "Installing $npkg via npm..."
  sudo npm install -g "$npkg"
done

success "All dependencies installed successfully."

