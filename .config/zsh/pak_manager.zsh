#!/bin/zsh

REPO_URL="https://github.com"

# Time threshold
TIME_THRESHOLD=604800    # 1 week in seconds
# TIME_THRESHOLD=10 # 20 hours in seconds

# Colors
RED='\033[0;31m'
NO_COLOR='\033[0m'
GREEN='\033[0;32m'
BRIGHT_CYAN='\033[0;96m'

#$1: Plugin's author
#$2: Plugin name
source_plugin() {
    if [ -f "$ZSH_PLUGIN_DIR/$2/$2.plugin.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$2/$2.plugin.zsh"
        loaded_plugins+=("$1/$2")
    elif [ -f "$ZSH_PLUGIN_DIR/$2/$2.zsh" ]; then
        source "$ZSH_PLUGIN_DIR/$2/$2.zsh"
        loaded_plugins+=("$1/$2")
    #Este ultimo para powerlevel10k
    elif [ -f "$ZSH_PLUGIN_DIR/$2/$2.zsh-theme" ]; then
        source "$ZSH_PLUGIN_DIR/$2/$2.zsh-theme"
        loaded_plugins+=("$1/$2")
    else
        echo -e "${RED}Error adding plugin${NO_COLOR} $2"
    fi
}

# Adds a plugin and sources it.
# $1: user/plugin
# $2: extra git params
add_plugin() {
    AUTHOR=$(echo "$1" | cut -d "/" -f 1)
    PLUGIN_NAME=$(echo "$1" | cut -d "/" -f 2)

    #Se comprueba si existe el directorio, indicando que se ha descargado
    if [ ! -d "$ZSH_PLUGIN_DIR/$PLUGIN_NAME" ]; then
        raw_msg="Installing $PLUGIN_NAME"
        print_message "Installing $GREEN$PLUGIN_NAME$NO_COLOR" "$(($COLUMNS - 4))" "$BRIGHT_CYAN#$NO_COLOR" "${#raw_msg}"

        # Si se pide algun comando extra a git, se pone como entrada a la funcion
        if [ "$#" -eq 2 ]; then
            git clone "$2" "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        else
            git clone "$REPO_URL/$1" "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        fi

        #Solo en caso de que haya tenido exito el clonado
        if [ "$?" -eq 0 ]; then
        #Se le añade una marca de tiempo para que cuando pase un tiempo determinado haga pull al plugin indicado
        date +%s >"$ZSH_PLUGIN_DIR/.$PLUGIN_NAME"
        else
        echo -e "${RED}Error installing $PLUGIN_NAME${NO_COLOR}"
        fi

    # En caso de haberse pasado esa marca de tiempo, se le hace un pull al plugin para obtener los cambios
    elif [ $(($(date +%s) - $(cat "$ZSH_PLUGIN_DIR/.$PLUGIN_NAME"))) -ge $TIME_THRESHOLD ]; then
        raw_msg="Updating $PLUGIN_NAME"
        print_message "Updating $GREEN$PLUGIN_NAME$NO_COLOR" "$(($COLUMNS - 4))" "$BRIGHT_CYAN#$NO_COLOR" "${#raw_msg}"

        cd "$ZSH_PLUGIN_DIR/$PLUGIN_NAME"
        git pull
        cd $HOME # JUST IN CASE
        date +%s >"$ZSH_PLUGIN_DIR/.$PLUGIN_NAME"
    fi

    source_plugin "$AUTHOR" "$PLUGIN_NAME"
}

#\\033\[0;?[0-9]*m to find ansi escape codes

#Prints a message given a max length. It fills the remaining space with "#"
#$1: Message to be printed
#$2: Max length of the message (including the message itself)
#$3: Character to fill the remaining space. It can be colored
#$4 (optional): Message length. Useful when it has ANSI escape codes, since it detects them as characters.
print_message() {
    msg_length=${#1}

    if [ $# -eq 4 ]; then
        msg_length=$4
    fi

    max_length="$2"
    hashtag_nro=$(((max_length - $msg_length - 2) / 2))
    #echo "hash: $hashtag_nro"
    
    printf "\n"
    printf "%0.s$3" $(seq 1 $2)
    printf "\n"
    printf "%0.s$3" $(seq 1 $hashtag_nro)
    if [ $(($msg_length % 2)) -ne 0 ]; then
        printf " %b  " $1
    else
        printf " %b " $1
    fi
    printf "%0.s$3" $(seq 1 $hashtag_nro)
    printf "\n"
    printf "%0.s$3" $(seq 1 $2)
    printf "\n"    
}



update_plugins(){
    for i in "${loaded_plugins[@]}"
    do
        echo "$i"
    done
}