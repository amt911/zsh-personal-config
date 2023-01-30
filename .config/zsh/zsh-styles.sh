#!/bin/sh

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
#_ls_colors='no=00;37:fi=00:di=01;33:ln=04;36:pi=40;33:so=01;35:bd=40;33;01:'

#Modificación del framework Prezto, cambiando el color de los directorios y de los programas
_ls_colors=${_ls_colors:-'di=01;94:ln=35:so=32:pi=33:ex=93:bd=36;01:cd=33;01:su=31;40;07:sg=36;40;07:tw=32;40;07:ow=33;40;07:'}
zstyle ':completion:*:default' list-colors ${(s.:.)_ls_colors}