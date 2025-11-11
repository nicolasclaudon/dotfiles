# Modern TMux Configuration Setup

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a modern tmux configuration with smart pane navigation, Catppuccin colorscheme, and a styled status bar integrated into your dotfiles.

**Architecture:** Uses tpm (tmux plugin manager) for plugin management. Core setup includes vim-tmux-navigator for vim-like pane navigation, Catppuccin theme, and a right-aligned status bar showing time, battery, and git info. Configuration files organized in `tmux/` directory following XDG conventions and symlinked via install.sh.

**Tech Stack:** tmux, tpm, vim-tmux-navigator, Catppuccin Mocha, Starship integration

---

## Task 1: Create TMux Directory Structure

**Files:**
- Create: `/Users/nico/dotfiles/tmux/tmux.conf`
- Create: `/Users/nico/dotfiles/tmux/catppuccin.tmux`

**Step 1: Create tmux directory**

```bash
mkdir -p /Users/nico/dotfiles/tmux
```

**Step 2: Create tmux.conf with core settings**

Create `/Users/nico/dotfiles/tmux/tmux.conf` with:

```tmux
# TMux Configuration
# Modern setup with vim-like navigation and Catppuccin theme

# Use 256 colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",*256col*:RGB"

# Set prefix to Ctrl-Space (easier than Ctrl-b)
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

# Vi mode for copy/selection
setw -g mode-keys vi

# Enable mouse support
set -g mouse on

# Aggressive resize (allow resizing without affecting other sessions)
setw -g aggressive-resize on

# Start windows and panes from 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase history
set -g history-limit 10000

# Reduce escape time for Vim
set -g escape-time 10

# Focus events for terminal integration
set -g focus-events on

# Status bar styling
set -g status-position top
set -g status-interval 1
set -g status-left-length 100
set -g status-right-length 100

# Pane border styling
set -g pane-border-status bottom
set -g pane-border-format "#{pane_index} #{pane_title}"

# Window navigation
bind -n M-h select-window -t :-
bind -n M-l select-window -t :+

# Pane navigation with vim keys (requires vim-tmux-navigator plugin)
is_vim="ps aux | grep -q [n]vim"
bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"

# Pane resizing
bind -n M-H resize-pane -L 5
bind -n M-J resize-pane -D 5
bind -n M-K resize-pane -U 5
bind -n M-L resize-pane -R 5

# Split panes with intuitive keys
unbind %
bind | split-window -h -c "#{pane_current_path}"
unbind '"'
bind - split-window -v -c "#{pane_current_path}"

# Create new window in current path
bind c new-window -c "#{pane_current_path}"

# Reload config
bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

# Copy mode improvements
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-selection-and-cancel
bind -T copy-mode-vi C-v send-keys -X rectangle-toggle

# Load Catppuccin theme
source-file ~/.config/tmux/catppuccin.tmux

# Plugin Manager - Load tpm and plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-battery'
set -g @plugin 'tmux-plugins/tmux-online-status'

# Configure status bar with plugins
set -g status-left "#[bg=#{@crust},fg=#{@blue}] #S #[default]"
set -g status-right "#[bg=#{@surface0},fg=#{@text}] #(date '+%H:%M:%S') #[bg=#{@surface0},fg=#{@text}]  #{battery_percentage} #[bg=#{@surface0},fg=#{@text}]  #{online_status} #[default]"
set -g status-bg "#{@base}"
set -g status-fg "#{@text}"

# Window status styling
set -g window-status-format "#[bg=#{@surface0},fg=#{@text}] #I: #W #[default]"
set -g window-status-current-format "#[bg=#{@blue},fg=#{@base},bold] #I: #W #[default]"

# Initialize TPM (must be at the end)
run '~/.tmux/plugins/tpm/tpm'
```

**Step 3: Create Catppuccin theme file**

Create `/Users/nico/dotfiles/tmux/catppuccin.tmux` with:

```tmux
# Catppuccin Mocha color palette for tmux
# https://github.com/catppuccin/tmux

set -g @crust "#11111b"
set -g @mantle "#181825"
set -g @base "#1e1e2e"
set -g @surface0 "#313244"
set -g @surface1 "#45475a"
set -g @surface2 "#585b70"
set -g @overlay0 "#6c7086"
set -g @overlay1 "#7f849c"
set -g @overlay2 "#9399b2"
set -g @subtext0 "#a6adc8"
set -g @subtext1 "#bac2de"
set -g @text "#cdd6f4"
set -g @rosewater "#f5e0dc"
set -g @flamingo "#f2cdcd"
set -g @pink "#f5c2e7"
set -g @mauve "#cba6f7"
set -g @red "#f38ba8"
set -g @maroon "#eba0ac"
set -g @peach "#fab387"
set -g @yellow "#f9e2af"
set -g @green "#a6e3a1"
set -g @teal "#94e2d5"
set -g @sky "#89dceb"
set -g @sapphire "#74c7ec"
set -g @blue "#89b4fa"
set -g @lavender "#b4befe"
```

**Step 4: Verify files were created**

```bash
ls -la /Users/nico/dotfiles/tmux/
```

Expected: Two files listed: `tmux.conf` and `catppuccin.tmux`

---

## Task 2: Install TPM (Tmux Plugin Manager)

**Files:**
- Create: `~/.tmux/plugins/tpm/` (external to dotfiles)

**Step 1: Clone tpm repository**

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Expected: tpm repository cloned to `~/.tmux/plugins/tpm/`

**Step 2: Verify tpm installation**

```bash
ls -la ~/.tmux/plugins/tpm/
```

Expected: Multiple files including `tpm`, `bin/`, etc.

---

## Task 3: Update install.sh to Symlink TMux Config

**Files:**
- Modify: `/Users/nico/dotfiles/install.sh`

**Step 1: Read current install.sh**

Read the file to find the line that creates symlinks (around line 28-35)

**Step 2: Add tmux symlink to install.sh**

Add the following line after the other symlinks (after line 35, before `chmod 600 ~/.ssh/config`):

```bash
ln -sf "$DOTFILES_DIR/tmux" ~/.config/tmux
```

The complete symlink section should look like:
```bash
# Create symlinks
ln -sf "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
ln -sf "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile
ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/ssh/config" ~/.ssh/config
ln -sf "$DOTFILES_DIR/ghostty" ~/.config/ghostty
ln -sf "$DOTFILES_DIR/starship/starship.toml" ~/.config/starship.toml
ln -sf "$DOTFILES_DIR/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/tmux" ~/.config/tmux
```

**Step 3: Verify the edit**

```bash
grep -n "ln -sf.*tmux" /Users/nico/dotfiles/install.sh
```

Expected: Output showing the new tmux symlink line

---

## Task 4: Test TMux Configuration

**Files:**
- No new files

**Step 1: Run install.sh to create symlink**

```bash
cd /Users/nico/dotfiles
./install.sh
```

Expected: Output shows "Dotfiles installed!" and symlink created

**Step 2: Verify symlink**

```bash
ls -la ~/.config/tmux
```

Expected: Shows `tmux.conf` and `catppuccin.tmux` files

**Step 3: Start a new tmux session**

```bash
tmux new-session -s test
```

Expected: tmux starts with your configuration

**Step 4: Verify keybindings work**

Inside tmux:
- Press `Ctrl-Space` - should do nothing (prefix is set)
- Press `Ctrl-Space c` - should create a new window
- Type `:list-keys` to see all keybindings

Expected: Keybindings work as configured

**Step 5: Verify plugin manager loads**

Inside tmux:
- Press `Ctrl-Space` then `Shift-I` (capital I) - should install plugins
- Wait for plugin installation to complete

Expected: tpm plugins are installed

**Step 6: Exit tmux**

```bash
exit
```

Or press `Ctrl-Space d` to detach

---

## Task 5: Commit Changes

**Files:**
- Modified: `/Users/nico/dotfiles/install.sh`
- Created: `/Users/nico/dotfiles/tmux/tmux.conf`
- Created: `/Users/nico/dotfiles/tmux/catppuccin.tmux`

**Step 1: Check git status**

```bash
cd /Users/nico/dotfiles
git status
```

Expected: Shows modified `install.sh` and new files in `tmux/`

**Step 2: Stage files**

```bash
git add install.sh tmux/
```

**Step 3: Create commit**

```bash
git commit -m "feat: add modern tmux configuration with plugins and Catppuccin theme"
```

Expected: Commit created successfully

**Step 4: Verify commit**

```bash
git log -1 --oneline
```

Expected: Shows your new commit message

---

## Post-Implementation

After completing these tasks, you'll have:
- ✅ Modern tmux configuration in `tmux/` directory
- ✅ Smart pane navigation with `Ctrl-h/j/k/l`
- ✅ Catppuccin Mocha colorscheme
- ✅ Styled status bar with time, battery, and online status
- ✅ Plugin manager (tpm) integrated
- ✅ All integrated into your dotfiles with symlinks

**Next steps (optional):**
- Create session templates/shortcuts for your dev workflow
- Customize keybindings further as needed
- Add additional plugins from the tpm community repository
- Update CLAUDE.md with tmux setup documentation
