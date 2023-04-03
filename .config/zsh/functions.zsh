#!/bin/zsh

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
convert_png_to_jpg() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: convert_png_to_jpg <path>"
    else
        for f in "$1"/*.png; do
	        jpg_name=$(echo "$f" | sed "s/.png/.jpg/")
	        convert "$f" "$jpg_name"
        done
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
        echo "Example: batch_crop -f 33x33"
        return 1
    fi
}
