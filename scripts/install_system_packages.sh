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

success "All system packages installed or updated."
