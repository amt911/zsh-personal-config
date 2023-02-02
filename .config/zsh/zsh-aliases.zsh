#!/bin/zsh

#Zona para los alias
alias ls=lsd
alias tree="lsd --tree"
alias sudo="sudo "
alias dd="dd status=progress"

#yay aliases
alias yaycc="yay -Scc"  #Clear cache
alias yaylo="yay -Qtdq"     #List orphans
alias yayco="yay -Qtdq | yay -Rs -"  #Clear orphans
alias yaylmo="yay -Qqd | yay -Rsu --print -"    #List more orphans
alias yaycmo="yay -Qqd | yay -Rsu -"    #Clear more orphans

#git aliases
alias gitig="git clean -dfX"    #Clean ignored files
alias gitprunemain="git remote prune origin && git branch --merged origin/main | grep -v main | xargs git branch -d"
alias gitprunemaster="git remote prune origin && git branch --merged origin/master | grep -v master | xargs git branch -d"