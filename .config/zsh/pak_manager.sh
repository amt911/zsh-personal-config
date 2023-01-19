#!/bin/zsh

REPO_URL="https://github.com"

# Time threshold
TIME_THRESHOLD=604800    # 1 week in seconds
#TIME_THRESHOLD=20 # 20 hours in seconds

# Colors
RED='\033[0;31m'
NO_COLOR='\033[0m'
GREEN='\033[0;32m'
BRIGHT_CYAN='\033[0;96m'

source_plugin() {
    if [ -f "$ZSH_PLUGIN_DIR/$1/$1.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.zsh"

    elif [ -f "$ZSH_PLUGIN_DIR/$1/$1.plugin.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.plugin.zsh"

    #Este ultimo para powerlevel10k
    elif [ -f "$ZSH_PLUGIN_DIR/$1/$1.zsh-theme" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.zsh-theme"
    else
        echo -e "${RED}Error adding plugin${NO_COLOR} $PLUGIN_NAME"
    fi
}

# Adds a plugin and sources it.
# $1: user/plugin
# $2: extra git params
add_plugin() {
    PLUGIN_NAME=$(echo "$1" | cut -d "/" -f 2)

    #Se comprueba si existe el directorio, indicando que se ha descargado
    if [ ! -d "$ZSH_PLUGIN_DIR/$PLUGIN_NAME" ]; then
        echo -e "\n$BRIGHT_CYAN####################################$NO_COLOR Installing $GREEN$PLUGIN_NAME$NO_COLOR $BRIGHT_CYAN####################################$NO_COLOR"
        # Si se pide algun comando extra a git, se pone como entrada a la funcion
        if [ "$#" -eq 2 ]; then
            git clone "$2" "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        else
            git clone "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        fi

        #Se le añade una marca de tiempo para que cuando pase un tiempo determinado haga pull al plugin indicado
        date +%s >"$ZSH_PLUGIN_DIR/.$PLUGIN_NAME"

    # En caso de haberse pasado esa marca de tiempo, se le hace un pull al plugin para obtener los cambios
    elif [ $(($(date +%s) - $(cat "$ZSH_PLUGIN_DIR/.$PLUGIN_NAME"))) -ge $TIME_THRESHOLD ]; then
        echo "\n$BRIGHT_CYAN####################################$NO_COLOR Updating $GREEN$PLUGIN_NAME$NO_COLOR $BRIGHT_CYAN####################################$NO_COLOR"

        cd "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        git pull
        cd $HOME    # JUST IN CASE
        date +%s > "$ZSH_PLUGIN_DIR/.$PLUGIN_NAME"
    fi

    source_plugin "$PLUGIN_NAME"
}

update_plugin() {

}
