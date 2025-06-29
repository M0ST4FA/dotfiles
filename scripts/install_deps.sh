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

function install_git_packages() {
  
  GIT_INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
  GIT_PACKAGES_FILE="$DEPS_DIR/git.txt"

  info "Installing Git packages..."

  declare -A GIT_PACKAGES
  parse_kv_file "$GIT_PACKAGES_FILE" GIT_PACKAGES

  mkdir -p "$GIT_INSTALL_DIR"

  for repo_url in "${!GIT_PACKAGES[@]}"; do

    echo "$repo_url"

    dest_rel="${GIT_PACKAGES[$repo_url]}"
    dest_path="$GIT_INSTALL_DIR/$dest_rel"

    echo "$dest_rel"
    echo "$GIT_INSTALL_DIR"
    echo "$dest_path"

    if [[ -d "$dest_path" && -d "$dest_path/.git" ]]; then
      info "Updating $repo_url → $dest_rel"
      if git -C "$dest_path" rev-parse &>/dev/null; then
        git -C "$dest_path" pull --ff-only
      else
        warn "Broken Git repo at $dest_rel — deleting and recloning..."
        rm -rf "$dest_path"
        git clone --depth=1 "$repo_url" "$dest_path"
      fi
    else
      info "Cloning $repo_url → $dest_rel"
      rm -rf "$dest_path" 2>/dev/null || true
      git clone --depth=1 "$repo_url" "$dest_path"
    fi  
  done

  success "All Git packages installed or updated."

}

function install_system_packages() {
  info "Updating system package database and upgrading..."
  sudo pacman -Syu --noconfirm

  SYSTEM_PACKAGES=()
  parse_array_file "$DEPS_DIR/arch.txt" SYSTEM_PACKAGES

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
  parse_array_file "$DEPS_DIR/npm.txt" NPM_PACKAGES

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
install_git_packages
install_npm_packages

success "All dependencies installed successfully."

