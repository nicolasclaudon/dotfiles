#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
echo "Installing dotfiles from $DOTFILES_DIR..."

# ── Homebrew ──────────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── Formulae ──────────────────────────────────────────────────────────────────
brew install \
  zinit neovim starship \
  eza bat fzf zoxide ripgrep \
  tmux lazygit gh \
  fnm pnpm uv \
  terraform tflint

# ── Casks ─────────────────────────────────────────────────────────────────────
brew install --cask \
  orbstack \
  obsidian \
  1password \
  discord \
  ──────────
ln -sf "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.config/zsh/.zshrc
ln -sf "$DOTFILES_DIR/zsh/.zprofile" ~/.config/zsh/.zprofile
ln -sf "$DOTFILES_DIR/zsh/.zaliases" ~/.config/zsh/.zaliases
ln -sf "$DOTFILES_DIR/zsh/functions.zsh" ~/.config/zsh/functions.zsh
ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config
ln -sf "$DOTFILES_DIR/git/config" ~/.gitconfig
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/tmux" ~/.config/tmux
ln -sf "$DOTFILES_DIR/docker/config.json" ~/.docker/config.json
ln -sf "$DOTFILES_DIR/docker/daemon.json" ~/.docker/daemon.json

chmod 600 ~/.ssh/config

# ── SSH key ───────────────────────────────────────────────────────────────────
if [ -f ~/.ssh/id_ed25519 ]; then
  echo "Adding SSH key to keychain..."
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 2>/dev/null
else
  echo "No SSH key found, generating one..."
  ssh-keygen -t ed25519
fi

# ── Git identity ──────────────────────────────────────────────────────────────
if ! git config --global user.name &>/dev/null; then
  read -p "Git name: " git_name
  read -p "Git email: " git_email
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
fi

echo "✓ Dotfiles installed — restart your terminal"──────────────────────────
backup_if_exists() {
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "Backing up $1"
    mv "$1" "$1.backup"
  fi
}

# ── Backups ───────────────────────────────────────────────────────────────────
backup_if_exists ~/.zshenv
backup_if_exists ~/.config/zsh/.zshrc
backup_if_exists ~/.config/zsh/.zprofile
backup_if_exists ~/.config/zsh/.zaliases
backup_if_exists ~/.config/zsh/functions.zsh
backup_if_exists ~/.config/nvim
backup_if_exists ~/.config/tmux
backup_if_exists ~/.config/ghostty
backup_if_exists ~/.config/starship.toml
backup_if_exists ~/.ssh/config
backup_if_exists ~/.gitconfig
backup_if_exists ~/.docker/config.json
backup_if_exists ~/.docker/daemon.json

# ── Symlinks ──────────────────────────────────────────────────────── signal \
vlc \
  keka

# ── Zinit ─────────────────────────────────────────────────────────────────────
if [ ! -f "$HOMEBREW_PREFIX/opt/zinit/zinit.zsh" ]; then
  bash -c "$(curl --fail --show-error --silent --location \
    https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
fi

# ── fnm — default Node ────────────────────────────────────────────────────────
eval "$(fnm env)"
fnm install --lts

# ── Directories ───────────────────────────────────────────────────────────────
mkdir -p \
  ~/.config/zsh \
  ~/.local/share/zsh \
  ~/.local/share/gem \
  ~/.local/share/sonar \
  ~/.cache/zsh \
  ~/.cache/npm \
  ~/.cache/gem \
  ~/.local/state \
  ~/.ssh

chmod 700 ~/.ssh

# ── Backup function ─────────────────────────────────
