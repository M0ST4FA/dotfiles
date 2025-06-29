NPM_PACKAGES=()
parse_array_file "$DEPS_DIR/npm.txt" NPM_PACKAGES

info "Installing npm global packages..."
for npkg in "${NPM_PACKAGES[@]}"; do
  info "Installing $npkg via npm..."
  sudo npm install -g "$npkg"
done

success "All npm packages installed or updated."
