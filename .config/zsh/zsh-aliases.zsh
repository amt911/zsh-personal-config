#!/bin/zsh

if [ "$ZSH_ALIASES_ZSH" != yes ]; then
    ZSH_ALIASES_ZSH=yes
else
    return 0
fi 

source "$ZSH_CONFIG_DIR/zshpc-functions.zsh"
source "$ZSH_CONFIG_DIR/zsh-mgr/zsh-mgr-common-functions.zsh"

# Zona para los alias
if check_cmd_exists "lsd";
then
    alias ls=lsd
    alias tree="lsd --tree"
fi

# This is to expand other aliases
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
alias yayrmf="yay -Rdds"    # Forces remove a package BREAKING the system

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
alias lgit="lazygit"

# Remove config aliases
alias re="source $HOME/.zshrc"
alias rmzsh="rm -rf $ZSH_CONFIG_DIR $HOME/{.zshrc,.p10k.zsh} $ZSH_PLUGIN_DIR"
alias rmplugins="rm -rf $ZSH_PLUGIN_DIR"

# Print empty directories
alias printed="find . -type d -empty -print"

# Remove empty directories
alias rmed="find . -type d -empty -delete"

# rsync aliases
alias rsync_diff_upd_times_dry="rsync -rlpgoDcvn --delete"
alias rsync_diff_upd_times="rsync -rlpgoDcv --delete"

# LATEX Tools aliases
alias latexmkpdf="latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf"