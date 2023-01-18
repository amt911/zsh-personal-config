# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Created by newuser for 5.9

autoload -U compinit
compinit

source /usr/share/zinit/zinit.zsh
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light  zdharma-continuum/fast-syntax-highlighting 
zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light romkatv/powerlevel10k

#source neccesary files
source $ZSH_CONFIG_DIR/zsh-bindings.sh
source $ZSH_CONFIG_DIR/zsh-aliases.sh
source $ZSH_CONFIG_DIR/zsh-exports.sh
source $ZSH_CONFIG_DIR/zsh-styles.sh

#source package (plugin) manager
source $ZSH_CONFIG_DIR/pak_manager.sh

#Plugins
add_plugin "zdharma-continuum/fast-syntax-highlighting"

#Parser del man para comandos que no lo tienen
compdef _gnu_generic nvidia-smi grub-install


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
