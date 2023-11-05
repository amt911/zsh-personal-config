# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH_CONFIG_DIR="$HOME/.config/zsh"
export ZSH_PLUGIN_DIR="$HOME/.zsh-plugins"

# Source package (plugin) manager
source $ZSH_CONFIG_DIR/zsh-mgr/zsh-mgr.zsh


# Launch the completer
autoload -U compinit
compinit

# Source neccesary files
source $ZSH_CONFIG_DIR/zsh-exports.zsh
source $ZSH_CONFIG_DIR/zsh-functions.zsh
source $ZSH_CONFIG_DIR/zsh-aliases.zsh
source $ZSH_CONFIG_DIR/zsh-bindings.zsh
source $ZSH_CONFIG_DIR/zsh-styles.zsh

# Plugins

# Only loads this plugin and fzf's autocompletion if it (fzf) is installed
if [ $(check_fzf) -eq 0 ]; then
  source "$FZF_DIR_FILE_LOC/key-bindings.zsh"
  source "$FZF_DIR_FILE_LOC/completion.zsh"

  add_plugin "Aloxaf/fzf-tab"
fi

add_plugin "zsh-users/zsh-autosuggestions"
add_plugin "zsh-users/zsh-history-substring-search"
add_plugin "zdharma-continuum/fast-syntax-highlighting"
add_plugin "zsh-users/zsh-completions"
add_plugin "romkatv/powerlevel10k" "--depth=1"


# Man parser for tab completion on unsupported commands
compdef _gnu_generic nvidia-smi grub-install fc-cache userdel passwd ntfsfix fdupes


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh