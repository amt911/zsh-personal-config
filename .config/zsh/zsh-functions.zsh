#!/bin/zsh

if [ "$ZSH_FUNCTIONS_ZSHPC" != yes ]; then
    ZSH_FUNCTIONS_ZSHPC=yes
    echo "no sourceado"
else
    echo "sourceado"
    return 0
fi 

#Checks wether fzf is installed and prints the return value to stdout
check_fzf() {
    which fzf >/dev/null

    echo $?
}

check_mec() {
    which mec >/dev/null

    echo $?
}



check_distro() {
    distro=$(awk "/^NAME=/{print $1}" /etc/os-release | cut --delimiter="=" --fields=2 | sed "s/\"//g")

    # By default I select Arch Linux
    if [ "$distro" = "Ubuntu" ]; then
        # echo "Arch"
        FZF_DIR_FILE_LOC="/usr/share/doc/fzf/examples"
    else
        FZF_DIR_FILE_LOC="/usr/share/fzf"
    fi

    # echo $FZF_DIR_FILE_LOC 
}

check_distro


# Personal scripts rewritten to functions, so they can be called directly
# REWIRTE THIS FUNCTION SO IT CAN TAKE AN ARBITRARY AMOUNT OF SWITCHES
convert_png_to_jpg() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: convert_png_to_jpg [-r] <quality-number> <path>"
	echo "Example: convert_png_to_jpg ."
	echo "Example: convert_png_to_jpg -r ."
	echo "Example: convert_png_to_jpg -r 33 ."
    elif [ "$#" -eq 1 ]; then
        for f in "$1"/*.png; do
	        jpg_name=$(echo "$f" | sed "s/.png/.jpg/")
	        convert "$f" "$jpg_name"
        done
    elif [ "$#" -eq 2 ]; then
        for f in "$2"/**/*.png; do
	        jpg_name=$(echo "$f" | sed "s/.png/.jpg/")
	        convert "$f" "$jpg_name"
        done
    else
        for f in "$3"/**/*.png; do
	        jpg_name=$(echo "$f" | sed "s/.png/.jpg/")
	        convert "$f" -quality "$2" "$jpg_name"
        done
    fi
}

batch_resize(){
    if [ "$#" -eq 2 ]; then
        [ ! -d "resized" ] && mkdir resized
        
        for f in "$1"/*.png; do
            convert "$f" -resize "$2" -filter Point "resized/$f"
        done
    elif [ "$#" -eq 3 ]; then
        for f in "$2"/*.png; do
            convert "$f" -resize "$3" -filter Point "$f"
        done
    else
        echo "Usage: batch_resize [-f] <directory> <percentage>"
        echo "Example: batch_resize . 20%"
        echo "Example: batch_resize -f . 33%"
        return 1
    fi
}

batch_crop() {
    if [ "$#" -eq 2 ]; then
        [ ! -d "cropped" ] && mkdir cropped
        
        for f in "$1"/*.png; do
            convert "$f" -crop "$2" "cropped/$f"
        done
    elif [ "$#" -eq 3 ]; then
        for f in "$2"/*.png; do
            convert "$f" -crop "$3" "$f"
        done
    else
        echo "Usage: batch_crop [-f] <directory> {x}x{y}{+/-}{x}{+/-}{y}"
        echo "Example: batch_crop . 12x13+1+2"
        echo "Example: batch_crop -f . 33x33"
        return 1
    fi
}

shrink_png_lossy() {
	if [ "$#" -ne 2 ]; then
		echo "Usage: shrink_png_lossy {min-max} {image(s)}"
		return 1
	else
		pngquant --skip-if-larger --force --ext "-new.png" --quality "$1" --speed 1 --strip "$2"
	fi
}


# update_zshpc(){
#     git -C "$HOME/.zshpc" pull
# }

# Updates the plugin manager to the latest main commit.
update_zshpc(){
    local -r RAW_MSG="Updating personal config"     # Raw message to count character length
    local -r MSG="Updating ${GREEN}personal config${NO_COLOR}"      # Message formatted with colors

    print_message "$MSG" "$((COLUMNS - 4))" "$BRIGHT_CYAN#$NO_COLOR" "${#RAW_MSG}"

    if ! git -C "$HOME/.zshpc" pull; then
        local -r RAW_ERR_MSG="Error updating personal config"
        local -r ERR_MSG="${RED}Error updating personal config${NO_COLOR}"

        print_message "$ERR_MSG" "$((COLUMNS - 4))" "$RED#$NO_COLOR" "${#RAW_ERR_MSG}"

        return 1
    fi

    date +%s > "$ZSH_PLUGIN_DIR/.zshpc"

    return 0
}


export ZSHPC_TIME_THRESHOLD=10

# Auto-updates the manager when a week has passed
_auto_updater_zshpc(){
    if [ ! -f "$ZSH_PLUGIN_DIR/.zshpc" ]; then
        date +%s > "$ZSH_PLUGIN_DIR/.zshpc"
    fi
    
    if [ $(($(date +%s) - $(cat "$ZSH_PLUGIN_DIR/.zshpc"))) -ge $ZSHPC_TIME_THRESHOLD ]; then
        update_zshpc
    fi
}

_auto_updater_zshpc