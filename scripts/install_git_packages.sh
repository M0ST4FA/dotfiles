info "Installing Git packages..."

declare -A GIT_PACKAGES
parse_kv_file "$GIT_PACKAGES_FILE" GIT_PACKAGES

mkdir -p "$GIT_INSTALL_DIR"

for repo_url in "${!GIT_PACKAGES[@]}"; do

  dest_rel="${GIT_PACKAGES[$repo_url]}"
  dest_path="$GIT_INSTALL_DIR/$dest_rel"

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
