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