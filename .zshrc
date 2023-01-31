# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Created by newuser for 5.9

#Launch the completer
autoload -U compinit
compinit

#source neccesary files
#EXPERIMENTAL FILE
source $ZSH_CONFIG_DIR/functions.sh

source $ZSH_CONFIG_DIR/zsh-bindings.zsh
source $ZSH_CONFIG_DIR/zsh-aliases.zsh
source $ZSH_CONFIG_DIR/zsh-exports.zsh
source $ZSH_CONFIG_DIR/zsh-styles.zsh


#source package (plugin) manager
source $ZSH_CONFIG_DIR/pak_manager.zsh

#Plugins

#Only loads this plugin and fzf's autocompletion if it (fzf) is installed
if [ $(check_fzf) -eq 0 ]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh

  add_plugin "Aloxaf/fzf-tab"
fi

add_plugin "zsh-users/zsh-autosuggestions"
add_plugin "zsh-users/zsh-history-substring-search"
add_plugin "zdharma-continuum/fast-syntax-highlighting"
add_plugin "zsh-users/zsh-completions"
add_plugin "romkatv/powerlevel10k" "--depth=1"


#Parser del man para comandos que no lo tienen
compdef _gnu_generic nvidia-smi grub-install fc-cache


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh