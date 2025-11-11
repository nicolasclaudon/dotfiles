# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a **macOS dotfiles repository** that manages development environment configuration. It's not a software project but rather a collection of configuration files for shell, editor, and terminal tools.

The repository provides:
- Shell configuration (Zsh with Zinit plugin manager)
- Neovim setup (based on LazyVim framework)
- Terminal configuration (Ghostty)
- Shell prompt configuration (Starship)
- SSH configuration

## Project Structure

```
dotfiles/
├── zsh/              # Zsh shell configuration
│   ├── .zshenv       # Environment variables (XDG, Zinit paths)
│   ├── .zprofile     # Homebrew and PATH setup
│   └── .zshrc        # Shell features, plugins, aliases
├── nvim/             # Neovim configuration (LazyVim-based)
│   ├── init.lua      # Entry point (loads config/lazy.lua)
│   ├── lua/
│   │   ├── config/   # Core configuration
│   │   │   ├── lazy.lua      # Lazy.nvim setup
│   │   │   ├── options.lua   # Vim options customizations
│   │   │   ├── keymaps.lua   # Custom keybindings
│   │   │   └── autocmds.lua  # Autocommands
│   │   └── plugins/  # Custom plugin configurations
│   ├── .neoconf.json # Neoconf settings for LSP
│   ├── lazyvim.json  # LazyVim configuration metadata
│   └── stylua.toml   # Lua code formatter config
├── ghostty/          # Ghostty terminal configuration
├── starship/         # Starship prompt configuration
├── ssh/              # SSH configuration
├── install.sh        # Installation script (creates symlinks)
├── README.md         # Basic project overview
└── LICENSE           # License file
```

## Key Architecture Decisions

### Shell Management: Zinit
- Uses Zinit as plugin manager for Zsh (not Oh My Zsh)
- Plugins loaded with **turbo mode** for performance optimization
- Plugins include: zsh-autosuggestions, zsh-completions, zsh-syntax-highlighting
- Completion cache invalidates once per day to balance freshness and speed

### Neovim: LazyVim Framework
- Built on LazyVim (opinionated Neovim starter template)
- Uses Lazy.nvim for plugin management with lazy-loading enabled
- Configuration organized into modular Lua files
- `.neoconf.json` enables LSP configuration through Neoconf

### Modern CLI Tools (Aliases)
The setup replaces standard tools with modern alternatives:
- `ls` → `eza` (Rust alternative to ls)
- `cat` → `bat` (Rust syntax-highlighted cat)
- `cd` → `z` (Zoxide for smart directory navigation)
- `grep` → `rg` (Ripgrep for fast searching)

These require: `brew install neovim starship eza bat fzf zoxide ripgrep`

## Common Development Tasks

### Installation
```bash
cd ~/dotfiles
./install.sh
```

This creates symlinks from config files to their standard locations:
- `~/.zshenv`, `~/.zprofile`, `~/.zshrc` → `zsh/` directory
- `~/.config/nvim` → `nvim/` directory
- `~/.config/ghostty` → `ghostty/` directory
- `~/.config/starship.toml` → `starship/starship.toml`
- `~/.ssh/config` → `ssh/config`

### Adding/Modifying Configuration

- **Shell aliases/functions**: Edit `zsh/.zshrc`
- **Environment variables**: Edit `zsh/.zshenv` (loaded first) or `zsh/.zprofile` (Homebrew setup)
- **Neovim keymaps**: Edit `nvim/lua/config/keymaps.lua`
- **Neovim options**: Edit `nvim/lua/config/options.lua`
- **Neovim plugins**: Add specs to `nvim/lua/plugins/` (LazyVim handles loading via Lazy.nvim)
- **Terminal appearance**: Edit `ghostty/config`
- **Prompt appearance**: Edit `starship/starship.toml`

### Testing Configuration Changes
1. Source modified zsh files: `source ~/.zshrc` or `exec zsh`
2. Restart Neovim or reload config: `:luafile ~/.config/nvim/init.lua` or restart
3. Changes to symlinked files are immediately reflected without reinstalling

## Important Implementation Details

### SSH Configuration
- `install.sh` sets SSH config permissions to 600 (required for security)
- Script attempts to add SSH key to keychain: `ssh-add --apple-use-keychain ~/.ssh/id_ed25519`
- Requires pre-existing SSH key at `~/.ssh/id_ed25519` (script provides generation instructions if missing)

### Neovim LazyVim Integration
- `nvim/init.lua` is minimal—it only loads `config/lazy.lua`
- `config/lazy.lua` bootstraps Lazy.nvim and imports:
  - LazyVim core plugins via `"LazyVim/LazyVim"`
  - Custom plugins from `nvim/lua/plugins/`
- Default options/keymaps come from LazyVim (see `nvim/lua/config/` files for custom overrides)
- Plugin checker is enabled with notifications disabled to check for updates

### Zsh Performance Optimization
- Completion initialization optimized: checks if cache is older than 24 hours
- Plugins use **turbo mode** (`wait lucid` flags) to defer loading until first prompt
- `skip_global_compinit=1` prevents duplicate completion initialization
- Syntax highlighting loaded last to avoid slowing down plugin initialization

### XDG Directory Convention
Environment is configured to use XDG Base Directory Specification:
- `XDG_CONFIG_HOME=~/.config`
- `XDG_DATA_HOME=~/.local/share`
- `XDG_CACHE_HOME=~/.cache`
- `XDG_STATE_HOME=~/.local/state`

Tools follow this convention, keeping the home directory clean.

## File Modification Guidelines

When making changes:
1. **Keep configurations DRY**: Avoid duplicating settings across files
2. **Respect Zinit/Lazy.nvim structure**: Don't manually edit plugin load order; use their configuration mechanisms
3. **Test changes**: Source shell files and restart editor to verify
4. **Preserve backup functionality**: `install.sh` backs up existing configs with `.backup` suffix

## Color Scheme
Catppuccin Mocha color scheme is used throughout:
- Ghostty terminal colors configured in `ghostty/config`
- Starship colors defined in `starship/starship.toml`
- Neovim color scheme managed by LazyVim (TokyoNight default, Catppuccin available via plugins)
