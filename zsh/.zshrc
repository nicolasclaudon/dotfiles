# Zinit setup
#source "${ZINIT_HOME}/zinit.zsh"
source $HOMEBREW_PREFIX/opt/zinit/zinit.zsh

# Corporate certificate bundle
export NODE_EXTRA_CA_CERTS="$HOME/.local/share/certificates/root.pem"

# Disable unnecessary features
skip_global_compinit=1

# Starship prompt
eval "$(starship init zsh)"

# Smart completion (once per day)
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi

# Completion optimizations
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY

# Performance options
setopt NO_BEEP
setopt AUTO_CD
setopt GLOB_COMPLETE

# Plugins with turbo mode
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Modern CLI tools
zinit ice wait lucid atload'eval "$(zoxide init zsh)"'
zinit snippet /dev/null

zinit ice wait lucid atload'eval "$(fzf --zsh)"'
zinit snippet /dev/null

# Syntax highlighting LAST
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# fnm
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# Aliases
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias grep='rg'

# Create cache directory
mkdir -p ~/.zsh/cache
### End of Zinit's installer chunk
### End of Zinit's installer chunk
