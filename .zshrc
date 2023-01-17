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

#Zona para los alias
alias ls=lsd
alias tree="lsd --tree"
alias sudo="sudo "
alias dd="dd status=progress"

#TAMAÑO DEL HISTORIAL
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000


#Para que se puedan seleccionar con las flechas las opciones
zstyle ':completion:*' menu select

#BROKEN: Cambiar el color a las descripciones
zstyle ':completion:*:options' list-colors '=(-- *)=38;5;144'

#########################################################################################
################### ESTILOS EXTRAIDOS DEL MODULO COMPLETION DE PREZTO ###################
#Enlace: https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh#
#########################################################################################

#Ofrece ayudas en los comandos. Por ejemplo: mkdir TAB aparece que es una carpeta.
zstyle ':completion:*:options' auto-description '%d'

#Mensajes de ayuda, se tiene uno generico y se especifica cada vez mas
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'

#Permite que aparezcan mensajes de ayuda al darle TAB
zstyle ':completion:*' group-name ''

#Separa los matches en grupos (no se exactamente que hace)
zstyle ':completion:*:matches' group 'yes'

#Añade descripciones a las opciones de los comandos (sigo sin saber para que funciona)
zstyle ':completion:*:options' description 'yes'

#Supuestamente te da mas informacion en los archivos y comandos
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word. But make
# sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'


#Mejoras para kill para que sea similar a fish. NO INCLUYE insert-ids single, ya que se vuelve no interactiva la tabulacion.
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always

#Mejoras de tabulacion de man. Por ejemplo, si se hace "man print" y se le da tabulacion, aparece una ventana mas bonita
# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

#############################################
###FIN DE LOS COMANDSO EXTRAIDOS DE PREZTO###
#############################################

#Cambiar el color a las sugerencias de archivos
_ls_colors='no=00;37:fi=00:di=01;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'
zstyle ':completion:*:default' list-colors ${(s.:.)_ls_colors}

#Parser del man para comandos que no lo tienen
compdef _gnu_generic nvidia-smi


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
