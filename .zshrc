# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Created by newuser for 5.9

autoload -U compinit
compinit

source /usr/share/zinit/zinit.zsh
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
#zinit light zsh-users/zsh-syntax-highlighting
zinit light  zdharma-continuum/fast-syntax-highlighting 
zinit light zsh-users/zsh-completions
zinit ice depth=1; zinit light romkatv/powerlevel10k

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

alias ls=lsd
alias sudo="sudo "

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

#zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*' menu select
zstyle ':completion:*:options' list-colors '=(-- *)=38;5;144'

#_ls_colors=":ow=02;69"
_ls_colors='no=00;37:fi=00:di=01;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
zstyle ':completion:*:default' list-colors ${(s.:.)_ls_colors}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
