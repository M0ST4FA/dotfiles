# 🌟 My Dotfiles (Stow-based)

This repository contains my personal dotfiles and system configuration managed with [GNU Stow](https://www.gnu.org/software/stow/). It more than manages my dotfiles: it also has their dependencies and most of the packages I use.

## 🚀 Setup

1. **Clone the repo (with submodules):**

   ```bash
   git clone --recursive https://github.com/M0ST4FA/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script:**

   ```bash
   ./scripts/install.sh
   ```

This will install dependencies and stow all configs to your home directory.

## ➕ Adding New Configs

1. Place your config in `~/dotfiles/<package-name>`
2. Run:

   ```bash
   cd ~/dotfiles
   stow <package-name>
   ```

## ❌ Uninstall a Config

```bash
cd ~/dotfiles
stow -D <package-name>
```

## 💡 Notes

* Make sure any submodules are initialized with:

  ```bash
  git submodule update --init --recursive
  ```

* Avoid **absolute symlinks** inside the stow directory.

