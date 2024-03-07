#!/bin/zsh

if [ "$ZSH_FUNCTIONS_ZSHPC" != yes ]; then
    ZSH_FUNCTIONS_ZSHPC=yes
else
    return 0
fi 

source "$ZSH_CONFIG_DIR/zsh-mgr/generic-auto-updater.zsh"
source "$ZSH_CONFIG_DIR/zsh-mgr/zsh-mgr.zsh"

check_distro() {
    local -r DISTRO=$(awk 'BEGIN{OFS=FS="="} /^NAME=/{print substr($NF,2,length($NF)-2)}' /etc/os-release)

    # By default I select Arch Linux
    if [ "$DISTRO" = "Ubuntu" ]; then
        # echo "Arch"
        FZF_DIR_FILE_LOC="/usr/share/doc/fzf/examples"
    else
        FZF_DIR_FILE_LOC="/usr/share/fzf"
    fi
}

# Updates the plugin manager to the latest main commit.
update_zshpc(){
    _generic_updater "personal config" "$HOME/.zshpc"
    update_mgr
}


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