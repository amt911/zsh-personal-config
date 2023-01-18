#!/bin/sh

REPO_URL="https://github.com/"

add_plugin() {
    if [ ! -d "$ZSH_PLUGIN_DIR" ]
    then
        mkdir "$ZSH_PLUGIN_DIR"
    fi


    echo "$REPO_URL/$1"

    #git clone 
}

update_plugins() {
    echo "mec"
}