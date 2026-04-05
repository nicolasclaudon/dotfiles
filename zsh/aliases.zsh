# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias mk='mkdir -p'
alias dotfiles='cd ~/dotfiles'

# Shell
alias cls='clear'
alias reload='source ~/.config/zsh/.zshrc'

# Editors
alias vi='nvim'
alias vim='nvim'
alias zaliases='nvim ~/dotfiles/zsh/aliases.zsh'

# File tools
alias ls='eza --icons=always --group-directories-first'
alias ll='eza -la'
alias la='eza -la'
alias lt='eza --tree --level=2 --long --icons --git'
alias cat='bat'
alias grep='rg'
alias fcd='cd "$(fd --type d | fzf)"'
alias fvim='nvim $(fzf)'
alias fzfp='fzf --preview "bat --color=always --style=numbers {}"'
alias rf='rm -rf'

# Git
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gp='git push'
alias gpm='git push origin main'
alias gs='git status'
alias lg='lazygit'

# Tools
alias tf='terraform'
alias ip='curl ifconfig.me'
alias cd='z'
alias zi='zinit'

# Secrets
alias secrets='load_secrets'
