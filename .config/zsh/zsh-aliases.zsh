#!/bin/zsh

# Zona para los alias
alias ls=lsd
alias tree="lsd --tree"
alias sudo="sudo "
alias dd="dd status=progress"
alias cp="cp --reflink=auto"

# yay aliases
alias yaycc="yay -Scc"  #Clear cache
alias yaylo="yay -Qtdq"     #List orphans
alias yayco="yay -Qtdq | yay -Rs -"  #Clear orphans
alias yaylmo="yay -Qqd | yay -Rsu --print -"    #List more orphans
alias yaycmo="yay -Qqd | yay -Rsu -"    #Clear more orphans
alias yaylf="yay -Qm"   #List foreign packages
# git aliases
alias gitig="git clean -dfX"    #Clean ignored files
alias gitig2="git rm -rf --cached ."	#Clean ignored files that are present on the repo (when gitignore is added after creation"
alias gitprunemain="git switch main && git remote prune origin && git branch --merged | grep -v main | xargs git branch -d"
alias gitprunemaster="git switch master && git remote prune origin && git branch --merged | grep -v master | xargs git branch -d"
alias gss="git status"
alias ga="git add"
alias gc="git commit"
alias gr="git restore"
alias gren="git branch -m"
alias gm="git merge --no-ff"

alias re="source $HOME/.zshrc"
alias rmzsh="rm -rf $ZSH_CONFIG_DIR $HOME/{.zshrc,.p10k.zsh} $ZSH_PLUGIN_DIR"
alias rmplugins="rm -rf $ZSH_PLUGIN_DIR"
alias printed="find . -type d -empty -print"
alias rmed="find . -type d -empty -delete"