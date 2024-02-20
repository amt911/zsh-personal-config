#!/bin/zsh

if [ "$ZSH_FUNCTIONS_ZSHPC" != yes ]; then
    ZSH_FUNCTIONS_ZSHPC=yes
else
    return 0
fi 

source "$ZSH_CONFIG_DIR/zsh-mgr/generic-auto-updater.zsh"
source "$ZSH_CONFIG_DIR/zsh-mgr/zsh-mgr.zsh"

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

# Personal scripts rewritten to functions, so they can be called directly
# REWIRTE THIS FUNCTION SO IT CAN TAKE AN ARBITRARY AMOUNT OF SWITCHES
convert_png_to_jpg() {
    if [ "$#" -eq 0 ]; then
        echo "Usage: convert_png_to_jpg [-r] <quality-number> <path>"
        echo "Example: convert_png_to_jpg ."
        echo "Example: convert_png_to_jpg -r ."
        echo "Example: convert_png_to_jpg -r 33 ."
        return 1
    fi

    local f
    if [ "$#" -eq 1 ]; then
        for f in "$1"/*.png; do
	        jpg_name=${f/%.png/.jpg}
	        convert "$f" "$jpg_name"
        done

    elif [ "$#" -eq 2 ]; then
        for f in "$2"/**/*.png; do
	        jpg_name=${f/%.png/.jpg}
	        convert "$f" "$jpg_name"
        done
    else
        for f in "$3"/**/*.png; do
	        jpg_name=${f/%.png/.jpg}
	        convert "$f" -quality "$2" "$jpg_name"
        done
    fi
    unset f
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

# Updates the plugin manager to the latest main commit.
update_zshpc(){
    _generic_updater "personal config" "$HOME/.zshpc"
    update_mgr
}


export ZSHPC_TIME_THRESHOLD=604800    # 1 week in seconds
# export ZSHPC_TIME_THRESHOLD=10    # 1 week in seconds

# Auto-updates the personal config
_auto_updater_zshpc(){
    _generic_auto_updater "personal config" "$HOME/.zshpc" "$ZSHPC_TIME_THRESHOLD"
}

# $1 (Optional yes/no): Display legend?
check_zshpc_update_date(){
    _check_comp_update_date "zshpc" "$HOME/.zshpc" "$ZSHPC_TIME_THRESHOLD" "Repo name#Next update" "${GREEN}" "${1:-yes}"
}

# $1 (Optional yes/no): Display legend? Default: yes
ck_all(){
    check_zshpc_update_date no
    ck_mgr_plugin no

    [ "${1:-yes}" = "yes" ] && _display_color_legend    
}

check_distro
_auto_updater_zshpc