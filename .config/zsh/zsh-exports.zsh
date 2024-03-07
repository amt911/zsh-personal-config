#!/bin/zsh

if [ "$ZSH_EXPORTS_ZSH" != yes ]; then
    ZSH_EXPORTS_ZSH=yes
else
    return 0
fi 

#TAMAÑO DEL HISTORIAL
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

# Para colorizar el manual (que yo sepa, seguramente tenga mas usos)
# Extraido de Prezto, en el modulo environment
zmodload zsh/termcap
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.


# Options to avoid duplication in the history file
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

export FZF_DIR_FILE_LOC="/usr/share/fzf/"       # Arch Linux location by default

export ZSHPC_TIME_THRESHOLD=604800    # 1 week in seconds
export TIME_THRESHOLD=604800        # 1 week in seconds
export MGR_TIME_THRESHOLD=604800    # 1 week in seconds


# Modificación del framework Prezto, cambiando el color de los directorios y de los programas
export LS_COLORS=${LS_COLORS:-'di=01;94:ln=35:so=32:pi=33:ex=93:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}
