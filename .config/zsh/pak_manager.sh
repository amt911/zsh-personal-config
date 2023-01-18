#!/bin/zsh

REPO_URL="https://github.com"


source_plugin() {
    if [ -f "$ZSH_PLUGIN_DIR/$1/$1.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.zsh"

    elif [ -f "$ZSH_PLUGIN_DIR/$1/$1.plugin.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$1/$1.plugin.zsh"
    else
        RED='\033[0;31m'
        NO_COLOR='\033[0m'
        echo -e "${RED}Error adding plugin${NO_COLOR} $PLUGIN_NAME"
    fi
}

add_plugin() {
    PLUGIN_NAME=$(echo "$1" | cut -d "/" -f 2)

    if [ ! -d "$ZSH_PLUGIN_DIR/$PLUGIN_NAME" ]; then
        git clone "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
    fi

    source_plugin "$PLUGIN_NAME"
}

update_plugins() {
    echo "mec"
}
