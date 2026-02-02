#!/bin/zsh

if [ "$ZSH_FUNCTIONS_ZSHPC" != yes ]; then
    ZSH_FUNCTIONS_ZSHPC=yes
else
    return 0
fi

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
    echo "${BRIGHT_CYAN}Updating zsh-personal-config...${RESET_COLOR}"
    
    # Update the config repo
    if [ -d "$HOME/.zshpc/.git" ]; then
        git -C "$HOME/.zshpc" pull
    fi
    
    # Update zsh-mgr submodule
    if [ -d "$HOME/.config/zsh/zsh-mgr/.git" ]; then
        git -C "$HOME/.config/zsh/zsh-mgr" pull
        
        # Rebuild zsh-mgr if using local build
        if [ ! -f "/usr/bin/zsh-mgr" ] && [ ! -f "/usr/local/bin/zsh-mgr" ]; then
            if command -v cargo &> /dev/null; then
                echo "${BRIGHT_CYAN}Rebuilding zsh-mgr...${RESET_COLOR}"
                cd "$HOME/.config/zsh/zsh-mgr/zsh-mgr-rs"
                cargo build --release
                mkdir -p "$HOME/.local/bin"
                cp target/release/zsh-mgr "$HOME/.local/bin/"
                echo "${GREEN}zsh-mgr rebuilt successfully${RESET_COLOR}"
            fi
        fi
    fi
    
    # Update all plugins
    if command -v zsh-mgr &> /dev/null; then
        echo "${BRIGHT_CYAN}Updating plugins...${RESET_COLOR}"
        zsh-mgr update
    fi
    
    echo "${GREEN}Update complete!${RESET_COLOR}"
}


# Check all update dates using zsh-mgr
ck_all(){
    if command -v zsh-mgr &> /dev/null; then
        echo "${BRIGHT_CYAN}Plugin and Manager Status:${RESET_COLOR}"
        zsh-mgr check
    else
        echo "${RED}zsh-mgr not found. Please install it.${RESET_COLOR}"
    fi
}

check_distro