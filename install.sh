#!/bin/bash
set -e

# ── Options ───────────────────────────────────────────────────────────────────
LINKS_ONLY=false
for arg in "$@"; do
  case "$arg" in
  -l | --links-only)
    LINKS_ONLY=true
    ;;
  -h | --help)
    echo "Usage: install.sh [--links-only|-l]"
    echo "  --links-only, -l   Only create symlinks (skip brew, ssh, fnm, npm)"
    exit 0
    ;;
  *)
    echo "Unknown option: $arg" >&2
    echo "Usage: install.sh [--links-only|-l]" >&2
    exit 1
    ;;
  esac
done

# Resolve the dotfiles directory from this script's location, so it works
# no matter where the repo is cloned.
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "Installing dotfiles from $DOTFILES_DIR..."

if [ "$LINKS_ONLY" = true ]; then
  echo "(links-only mode — skipping brew, ssh, fnm, npm)"
fi

# ── Homebrew ──────────────────────────────────────────────────────────────────
if [ "$LINKS_ONLY" = false ] && ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ "$LINKS_ONLY" = false ]; then
  # ── Formulae ──────────────────────────────────────────────────────────────────
  brew install \
    fish neovim \
    eza bat fd fzf zoxide ripgrep \
    dust duf ncdu procs sd git-delta \
    atuin \
    jq yq glow tealdeer btop yazi \
    tmux lazygit gh \
    fnm pnpm uv \
    fabric-ai \
    herd \
    1password-cli

  # ── Casks ─────────────────────────────────────────────────────────────────────
  brew install --cask \
    ghostty \
    orbstack \
    obsidian \
    1password \
    discord \
    vlc \
    keka

fi

# ── Default shell — fish ────────────────────────────────────────────────────
# Runs unconditionally (even with --links-only) so re-running the script
# can fix a shell that didn't get switched on a previous pass.
FISH_PATH="$(command -v fish)"
if [ -z "$FISH_PATH" ]; then
  echo "! fish not found — skipping default shell change (install fish first)"
else
  if ! grep -qx "$FISH_PATH" /etc/shells; then
    echo "Adding $FISH_PATH to /etc/shells..."
    echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  CURRENT_SHELL="$(dscl . -read "/Users/$(whoami)" UserShell 2>/dev/null | awk '{print $2}')"
  if [ "$CURRENT_SHELL" != "$FISH_PATH" ]; then
    echo "Changing default shell to fish..."
    chsh -s "$FISH_PATH"
  fi
fi

# ── Directories ───────────────────────────────────────────────────────────────
mkdir -p \
  ~/.config/git \
  ~/.local/share/gem \
  ~/.local/share/sonar \
  ~/.cache/npm \
  ~/.cache/gem \
  ~/.local/state \
  ~/.local/state/less \
  ~/.local/state/node \
  ~/.local/state/python \
  ~/.docker \
  ~/.ssh

chmod 700 ~/.ssh

# ── Symlink helper ────────────────────────────────────────────────────────────
# link <source-relative-to-dotfiles> <target-absolute-path>
# Backs up a pre-existing, non-symlink target to <target>.backup, then symlinks.
# Every target is recorded in LINK_TARGETS and verified at the end of the script,
# so a missing source (e.g. a config dir not yet added to the repo) fails loudly
# instead of being silently skipped.
LINK_TARGETS=()
link() {
  local src="$DOTFILES_DIR/$1"
  local dst="$2"
  LINK_TARGETS+=("$dst")

  if [ ! -e "$src" ]; then
    echo "✗ ERROR: cannot link $dst — source $src does not exist" >&2
    return
  fi

  # Back up a real file/dir (but not an existing symlink) once.
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up $dst -> $dst.backup"
    mv "$dst" "$dst.backup"
  fi

  mkdir -p "$(dirname "$dst")"
  ln -sfn "$src" "$dst"
  echo "linked $dst"
}

# ── Symlinks ──────────────────────────────────────────────────────────────────
link ssh/config ~/.ssh/config
link git/config ~/.config/git/config
link git/ignore ~/.config/git/ignore
link bin ~/bin
link fish ~/.config/fish
link claude ~/.config/claude
link ghostty ~/.config/ghostty
link herdr ~/.config/herdr
link nvim ~/.config/nvim
link tmux ~/.config/tmux
link pi/models.json ~/.pi/agent/models.json
link docker/config.json ~/.docker/config.json
link docker/daemon.json ~/.docker/daemon.json
link launchd/com.homebrew.update.plist ~/Library/LaunchAgents/com.homebrew.update.plist

# ── Homebrew auto-update LaunchAgent ─────────────────────────────────────────
if [ "$LINKS_ONLY" = false ]; then
  launchctl bootout "gui/$(id -u)" ~/Library/LaunchAgents/com.homebrew.update.plist 2>/dev/null || true
  launchctl bootstrap "gui/$(id -u)" ~/Library/LaunchAgents/com.homebrew.update.plist
  echo "✓ com.homebrew.update LaunchAgent loaded (daily at 11:00)"
fi

chmod 600 ~/.ssh/config

# ── Verify symlinks ───────────────────────────────────────────────────────────
# Fail the install if any expected link is missing or broken, so a config that
# silently didn't get linked (like fish previously) can't slip through.
LINK_ERRORS=0
for dst in "${LINK_TARGETS[@]}"; do
  if [ ! -L "$dst" ]; then
    echo "✗ $dst is not a symlink" >&2
    LINK_ERRORS=1
  elif [ ! -e "$dst" ]; then
    echo "✗ $dst is a broken symlink" >&2
    LINK_ERRORS=1
  fi
done
if [ "$LINK_ERRORS" -eq 1 ]; then
  echo "! Install incomplete — fix the errors above and re-run." >&2
  exit 1
fi

echo "✓ All symlinks verified"

if [ "$LINKS_ONLY" = false ]; then
  # SSH keys are managed by the 1Password SSH agent (see ~/.ssh/config).

  # ── Fish plugins (fisher + tide, from fish/fish_plugins) ──────────────────────
  if command -v fish &>/dev/null; then
    echo "Installing fish plugins..."
    fish -c '
      if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        and fisher install jorgebucaran/fisher
      end
      fisher update
    '
  fi

  # ── fnm — default Node ────────────────────────────────────────────────────────
  eval "$(fnm env)"
  fnm install --lts
  fnm use lts-latest

  # ── Claude Code (official installer, installs to ~/.local/bin) ───────────────
  curl -fsSL https://claude.ai/install.sh | bash

  # ── pi coding agent (official installer, installs to ~/.local/bin) ───────────
  curl -fsSL https://pi.dev/install.sh | sh
fi

echo "✓ Dotfiles installed — restart your terminal"
