#!/bin/sh

#Checks wether fzf is installed and prints the return value to stdout
check_fzf() {
    which fzf >/dev/null

    echo $?
}

check_mec() {
    which mec >/dev/null

    echo $?
}
