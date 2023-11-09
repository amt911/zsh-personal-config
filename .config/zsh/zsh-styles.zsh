#!/bin/zsh

if [ "$ZSH_STYLES_ZSH" != yes ]; then
    ZSH_STYLES_ZSH=yes
else
    return 0
fi 


#If fzf is installed, it continues with its config
if [ $(check_fzf) -eq 0 ]; then
    #This styles are from the fzf-tab's readme.md

    # disable sort when completing `git checkout`
    zstyle ':completion:*:git-checkout:*' sort false

    # set descriptions format to enable group support
    zstyle ':completion:*:descriptions' format '[%d]'

    # preview directory's content with lsd when completing cd
    zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'

    # switch group using `,` and `.`
    zstyle ':fzf-tab:*' switch-group ',' '.'

else
    #En caso de no encontrar fzf, no añade fzf-tab y además incluye los estilos extraidos de Prezto
    #Esto se hace asi porque fzf-tab imprime los grupos mal: %F{yellow}-- ... ---%f
    zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
    zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
    zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
fi


#Para que se puedan seleccionar con las flechas las opciones y además se pueda buscar en los menús
# zstyle ':completion:*' menu select
zstyle ':completion:*' menu select yes search interactive

#Estas dos lineas sirven para hacer busqueda case insensitive (solo sirve en el caso de los switches para el nombre, no
#para la descripcion)
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

#BROKEN: Cambiar el color a las descripciones
#zstyle ':completion:*:options' list-colors '=(-- *)=38;5;144'

#########################################################################################
################### ESTILOS EXTRAIDOS DEL MODULO COMPLETION DE PREZTO ###################
#Enlace: https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh#
#########################################################################################

#Ofrece ayudas en los comandos. Por ejemplo: mkdir TAB aparece que es una carpeta.
zstyle ':completion:*:options' auto-description '%d'

#Mensaje que aparece si no encuentra ninguna opción para completar
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

#Mensaje que indica el numero de letras que se han corregido al poner mal un comando
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'

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


zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
