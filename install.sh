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

# Remove nested symlinks within dotfiles directories
clean_nested_symlinks() {
  local target_dir="$1"
  local dir_name=$(basename "$target_dir")

  # Check for self-referential symlink (e.g., ghostty/ghostty or nvim/nvim)
  if [ -L "$target_dir/$dir_name" ]; then
    echo "Removing nested symlink: $target_dir/$dir_name"
    rm "$target_dir/$dir_name"
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
backup_if_exists ~/.gitconfig

# Create symlinks
ln -sf "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
ln -sf "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config
ln -sf "$DOTFILES_DIR/git/config" ~/.gitconfig
ln -sf "$DOTFILES_DIR/ghostty" ~/.config/ghostty
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/tmux" ~/.config/tmux

chmod 600 ~/.ssh/config

bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Add SSH key to keychain (if exists)
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "Adding SSH key to keychain..."
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
else
  echo "⚠ No SSH key found at ~/.ssh/id_ed25519"
  echo "Generate one with: ssh-keygen -t ed25519 -C 'your@email.com'"
  ssh-keygen -t ed25519
fi

# Prompt for git user info if not set
if ! git config --global user.name >/dev/null 2>&1; then
  echo "Git user info not configured."
  read -p "Enter your name: " git_name
  read -p "Enter your email: " git_email
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
fi

brew install zinit neovim starship eza bat fzf zoxide ripgrep tmux
brew install fnm pnpm #install node
brew install uv       #for python
brew install ghostty  #for terminal

fnm install --lts #install default node environment
echo "✓ Dotfiles installed!"
echo "Restart your terminal to apply changes."
