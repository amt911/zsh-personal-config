#!/bin/zsh

REPO_URL="https://github.com"

source_plugin() {
    if [ -f "$ZSH_PLUGIN_DIR/$1/$1.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.zsh"

    elif [ -f "$ZSH_PLUGIN_DIR/$1/$1.plugin.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.plugin.zsh"

    #Este ultimo para powerlevel10k
    elif [ -f "$ZSH_PLUGIN_DIR/$1/$1.zsh-theme" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.zsh-theme"
    else
        RED='\033[0;31m'
        NO_COLOR='\033[0m'
        echo -e "${RED}Error adding plugin${NO_COLOR} $PLUGIN_NAME"
    fi
}

add_plugin() {
    PLUGIN_NAME=$(echo "$1" | cut -d "/" -f 2)

    #Se comprueba si existe el directorio, indicando que se ha descargado
    if [ ! -d "$ZSH_PLUGIN_DIR/$PLUGIN_NAME" ]; then

        # Si se pide algun comando extra a git, se pone como entrada a la funcion
        if [ "$#" -eq 2 ]; then
        git clone "$2" "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        else
        git clone "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        fi

    fi

    source_plugin "$PLUGIN_NAME"
}

update_plugins() {
    echo "mec"
}
