#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

echo "Installing dotfiles from $DOTFILES_DIR..."

# Create directories
mkdir -p ~/.config ~/.local/share ~/.cache ~/.local/state

# Backup function
backup_if_exists() {
    if [ -e "$1" ] && [ ! -L "$1" ]; then
        echo "Backing up $1"
        mv "$1" "$1.backup"
    fi
}

# Backup existing configs
backup_if_exists ~/.zshenv
backup_if_exists ~/.zprofile
backup_if_exists ~/.zshrc
backup_if_exists ~/.config/ghostty
backup_if_exists ~/.config/starship.toml
backup_if_exists ~/.config/nvim

# Create symlinks
ln -sf "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
ln -sf "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/ghostty" ~/.config/ghostty
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim

echo "✓ Dotfiles installed!"
echo "Restart your terminal to apply changes."
