#!/bin/zsh

#Zona para los alias
alias ls=lsd
alias tree="lsd --tree"
alias sudo="sudo "
alias dd="dd status=progress"
alias yaycc="yay -Scc"  #Clear cache
alias yaylo="yay -Qtdq"     #List orphans
alias yayco="yay -Qtdq | yay -Rs -"  #Clear orphans
alias yaylmo="yay -Qqd | yay -Rsu --print -"    #List more orphans
alias yaycmo="yay -Qqd | yay -Rsu -"    #Clear more orphans
alias re="source $HOME/.zshrc"
alias rmzsh="rm -rf $ZSH_CONFIG_DIR $HOME/{.zshrc,.p10k.zsh}"
alias rmplugins="rm -rf $ZSH_PLUGIN_DIR"