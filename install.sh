#!/usr/bin/env bash
set -e # Exit on error

echo "Installing dependencies..."

echo "🌀 Installing dotfiles with GNU Stow..."

# List of stow packages
PACKAGES=(
  "hyprland" 
  "nvim" 
  "zsh" 
  "ssh"
  "git" 
  "bat" 
  "htop" 
  "kitty" 
  "scripts"
)

for pkg in "${PACKAGES[@]}"; do
  echo "🔗 Stowing $pkg..."
  stow -v -R "$pkg"
done

echo "✅ Dotfiles installed!"
