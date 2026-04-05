# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Path
export PATH="$HOME/.local/bin:$PATH"


# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

export TF_DATA_DIR=$XDG_DATA_HOME/terraform
export TFLINT_PLUGIN_DIR=$XDG_DATA_HOME/tflint/plugins

export NPM_CONFIG_CACHE=$XDG_CACHE_HOME/npm:XDG_DATA_HOME
export GEM_HOME=$XDG_DATA_HOME/gem
export GEM_SPEC_CACHE=$XDG_CACHE_HOME/gem
export PATH=$GEM_HOME/bin:$PATH

export PATH="$HOME/.bin:$PATH"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
