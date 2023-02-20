#!/bin/zsh

export ZSH_PLUGIN_DIR="$HOME/.zsh-plugins"

#TAMAÑO DEL HISTORIAL
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

#Para colorizar el manual (que yo sepa, seguramente tenga mas usos)
# Extraido de Prezto, en el modulo environment
zmodload zsh/termcap
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.