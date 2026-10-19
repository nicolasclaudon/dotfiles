# ~/.config/fish/config.fish

# ── PATH ──────────────────────────────────────────────────────────────────────
# Homebrew (Apple Silicon)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin

# Personal binaries
fish_add_path ~/bin
fish_add_path ~/.local/bin

# ── Environment ───────────────────────────────────────────────────────────────
# Editor — also used by git, less, etc.
set -gx EDITOR nvim
set -gx VISUAL nvim

# Use bat as the pager for `man` and colored --help output.
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c

# ── Tidy $HOME: relocate tool history into ~/.local/state (XDG) ────────────────
set -gx LESSHISTFILE $HOME/.local/state/less/history
set -gx NODE_REPL_HISTORY $HOME/.local/state/node/repl_history
set -gx PYTHON_HISTORY $HOME/.local/state/python/history # Python 3.13+

# Keep Claude Code config under XDG ~/.config instead of ~/.claude
set -gx CLAUDE_CONFIG_DIR $HOME/.config/claude

# ── Secrets via 1Password (example) ───────────────────────────────────────────
# SSH keys are served by the 1Password agent, configured in ~/.ssh/config
# (IdentityAgent). No SSH_AUTH_SOCK needed here.
#
# Fetch secrets on demand rather than storing them in dotfiles, e.g.:
#   set -gx GITHUB_TOKEN (op read "op://Private/GitHub Token/credential")
# (You already do this per-script, e.g. ~/bin/myclaude.sh.)

# ── Homebrew completions ──────────────────────────────────────────────────────
if test -d (brew --prefix)"/share/fish/completions"
    set -p fish_complete_path (brew --prefix)/share/fish/completions
end
if test -d (brew --prefix)"/share/fish/vendor_completions.d"
    set -p fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
end

# ── Interactive-only settings ─────────────────────────────────────────────────
# Everything below runs only in interactive shells (not scripts / ssh commands).
if status is-interactive
    # Suppress the greeting
    set -g fish_greeting

    # ── Modern CLI replacements ───────────────────────────────────────────────
    # eza → ls (colors, icons, git status, dirs first). Replaces ls entirely.
    # This eza build prints nothing for a no-path listing when stdout isn't a
    # TTY (e.g. `ls | grep`), so we default to "." when no path operand is given.
    function _eza_ls
        set -l has_operand 0
        for a in $argv
            string match -q -- '-*' $a; or set has_operand 1
        end
        test $has_operand -eq 1; or set -a argv .
        eza --group-directories-first --icons=auto $argv
    end
    function ls --wraps eza --description 'eza as ls'
        _eza_ls $argv
    end
    function ll --wraps eza --description 'eza long + git'
        _eza_ls -l --git $argv
    end
    function la --wraps eza --description 'eza long + all + git'
        _eza_ls -la --git $argv
    end
    function lt --wraps eza --description 'eza tree'
        _eza_ls --tree --level=2 $argv
    end

    # bat → cat (syntax highlighting). Pipe-aware: acts like plain cat when piped.
    abbr cat 'bat --paging=never'

    # zoxide → smart directory jumping. `cd` stays native; adds `z` and `zi`.
    if command -q zoxide
        zoxide init fish | source
    end

    # fzf → fuzzy finder key bindings: Ctrl-R history, Ctrl-T files, Alt-C cd.
    if command -q fzf
        fzf --fish | source
    end

    # Atuin is a replacement for navigating the history
    if command -q atuin
        atuin init fish | source
    end

    # switch to the correct node verrsion required by the directory
    if command -q fnm
        fnm env --use-on-cd --shell fish | source
    end

    # More modern replacements (abbreviations — expand inline).
    abbr du dust # disk usage, visual tree
    abbr df duf # disk free, pretty table
    abbr ps procs # process list
    abbr topd ncdu # interactive disk-usage browser
    abbr md glow # render markdown in the terminal
    abbr rf 'rm -rf' # force-remove files/dirs recursively
    abbr vim nvim # edit with neovim
    abbr vi nvim # edit with neovim
    abbr l ls

    # yazi → terminal file manager. `y` opens it and cd's to wherever you
    # navigated when you quit (press q). Use Q to quit without changing dir.
    function y
        set -l tmp (mktemp -t yazi-cwd.XXXXXX)
        yazi $argv --cwd-file=$tmp
        if set -l cwd (command cat -- $tmp); and test -n "$cwd"; and test "$cwd" != "$PWD"
            builtin cd -- "$cwd"
        end
        rm -f -- $tmp
    end

    # ── Abbreviations ─────────────────────────────────────────────────────────
    # Expand inline as you type, so the real command lands in your history.
    # git
    abbr g git
    abbr gs git status
    abbr ga git add
    abbr gc git commit
    abbr gcm git commit -m
    abbr gco git checkout
    abbr gd git diff
    abbr gl git log --oneline --graph --decorate
    abbr gp git push
    abbr gpl git pull
    abbr gb git branch

    # editor / misc
    abbr v nvim
    abbr lg lazygit

    # fabric-ai: `fabric` wrapper in ~/bin injects the Capgemini API key
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
