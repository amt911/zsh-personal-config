# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Launch the completer
autoload -U compinit
compinit

export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Source all scripts
source $ZSH_CONFIG_DIR/zsh-sources.zsh

# Plugins - loaded automatically from $ZSH_PLUGIN_DIR
# Use 'zsh-mgr add <user/repo>' to add new plugins
# Use 'zsh-mgr list' to see installed plugins
# Use 'zsh-mgr update' to update all plugins
# Use 'zsh-mgr check' to see next update dates

# Only loads fzf's autocompletion if it is installed
if check_cmd_exists "fzf"; then
  source "$FZF_DIR_FILE_LOC/key-bindings.zsh"
  source "$FZF_DIR_FILE_LOC/completion.zsh"
fi


# Man parser for tab completion on unsupported commands
compdef _gnu_generic nvidia-smi grub-install fc-cache userdel passwd ntfsfix fdupes bc test

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh