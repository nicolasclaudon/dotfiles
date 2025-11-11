#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

echo "Installing dotfiles from $DOTFILES_DIR..."

# Create directories
mkdir -p ~/.config ~/.local/share ~/.cache ~/.local/state ~/.ssh
chmod 700 ~/.ssh

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
backup_if_exists ~/.config/tmux
backup_if_exists ~/.ssh/config

# Create symlinks
ln -sf "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
ln -sf "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config
ln -sf "$DOTFILES_DIR/ghostty" ~/.config/ghostty
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/tmux" ~/.config/tmux

chmod 600 ~/.ssh/config

# Add SSH key to keychain (if exists)
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "Adding SSH key to keychain..."
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
else
  echo "⚠ No SSH key found at ~/.ssh/id_ed25519"
  echo "Generate one with: ssh-keygen -t ed25519 -C 'your@email.com'"
fi

echo "✓ Dotfiles installed!"
echo "Restart your terminal to apply changes."
