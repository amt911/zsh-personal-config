#!/bin/zsh

if [ "$ZSH_BINDINGS_ZSH" != yes ]; then
    ZSH_BINDINGS_ZSH=yes
    echo "no sourceado"
else
    echo "sourceado"
    return 0
fi 

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char