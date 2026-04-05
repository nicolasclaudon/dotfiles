# ── Zinit ─────────────────────────────────────────────────────────────────────
source $HOMEBREW_PREFIX/opt/zinit/zinit.zsh
skip_global_compinit=1

# ── Prompt ────────────────────────────────────────────────────────────────────
eval "$(starship init zsh)"

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $XDG_CACHE_HOME/zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE=$XDG_DATA_HOME/zsh/history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_VERIFY

# ── Options ───────────────────────────────────────────────────────────────────
setopt NO_BEEP AUTO_CD GLOB_COMPLETE

# ── Plugins ───────────────────────────────────────────────────────────────────
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit light zsh-users/zsh-history-substring-search

# ── Key bindings ──────────────────────────────────────────────────────────────
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── CLI tools ─────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls='eza'
alias ll='eza -la'
alias cat='bat'
alias vim='nvim'
alias vi='nvim'
alias grep='rg'
alias cd='z'

# ── Secrets (run `secrets` to load) ──────────────────────────────────────────

op_env() {
  local secret
  secret=$(printf '{{ op://Personal/%s/identifiant }}' "$2" | op inject)
  export "$1=$secret"
}

load_secrets() {
  if [ -z "$ANTHROPIC_API_KEY" ]; then
    op_env ANTHROPIC_API_KEY "Anthropic Portfolio Token"
    op_env OPENAI_API_KEY "OPENAI API KEY"
    op_env SONARQUBE_TOKEN "SONARQUBE LOCAL TOKEN"
    echo "Secrets loaded."
  fi
}
alias secrets="load_secrets"

# ── Auto-source ~/.config/zsh/*.zsh ───────────────────────────────────────────
for f in ~/.config/zsh/*.zsh; do
  [[ -f "$f" ]] && source "$f"
done