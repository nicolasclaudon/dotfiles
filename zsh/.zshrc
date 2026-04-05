# Zinit setup
source $HOMEBREW_PREFIX/opt/zinit/zinit.zsh

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
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# History
HISTFILE=$XDG_DATA_HOME/zsh/history
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
#zinit ice wait lucid atload'eval "$(zoxide init zsh)"'
#zinit snippet /dev/null

#zinit ice wait lucid atload'eval "$(fzf --zsh)"'
zinit snippet /dev/null


# Syntax highlighting LAST
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

# History substring search - MUST come after syntax-highlighting
zinit light zsh-users/zsh-history-substring-search

# Key bindings - set immediately after plugin loads
bindkey '^[[A' history-substring-search-up    # Up arrow
bindkey '^[[B' history-substring-search-down  # Down arrow

# fnm
#export PATH=/home/$USER/.fnm:/Users/$USER/.bin:$PATH
#eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"


# Modern CLI tools
eval "$(zoxide init zsh)" #search with ctrl r
eval "$(fzf --zsh)" #fuzzy finder
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)" #manage node version

# Aliases
source $HOME/.zaliases
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias grep='rg'
alias cd='z'

# Create cache directory
mkdir -p ~/.zsh/cache
### End of Zinit's installer chunk
### End of Zinit's installer chunk
export SONARQUBE_TOKEN=squ_354276591e9cce31d0272e7db205a8e8f397d895
export SONARQUBE_URL=http://192.168.138.16:9000

# Auto-source everything in ~/.config/zsh
for f in ~/.config/zsh/*.zsh; do
  [[ -f "$f" ]] && source "$f"
done
