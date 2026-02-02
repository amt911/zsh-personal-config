#!/bin/zsh

# zsh-mgr-init.zsh - Initialize the Rust-based zsh-mgr

if [ "$ZSH_MGR_INIT" != yes ]; then
    ZSH_MGR_INIT=yes
else
    return 0
fi

# Color definitions
export BRIGHT_CYAN='\033[1;36m'
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[1;33m'
export NO_COLOR='\033[0m'

# Add ~/.local/bin to PATH if it exists and not already in PATH
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Check if zsh-mgr is installed
if ! command -v zsh-mgr &> /dev/null; then
    echo "${YELLOW}Warning: zsh-mgr not found in PATH${NO_COLOR}"
    echo "Install with: sudo pacman -S zsh-mgr  (Arch Linux)"
    echo "Or build from source: cd ~/.config/zsh/zsh-mgr/zsh-mgr-rs && cargo build --release"
    return 1
fi

# Source all installed plugins
for plugin in "$ZSH_PLUGIN_DIR"/*/*.plugin.zsh; do
    if [ -f "$plugin" ]; then
        source "$plugin"
    fi
done

# Source any .zsh files from plugins that don't follow the .plugin.zsh convention
for plugin_dir in "$ZSH_PLUGIN_DIR"/*; do
    if [ -d "$plugin_dir" ]; then
        plugin_name=$(basename "$plugin_dir")
        
        # Special handling for specific plugins
        case "$plugin_name" in
            "powerlevel10k")
                [ -f "$plugin_dir/powerlevel10k.zsh-theme" ] && source "$plugin_dir/powerlevel10k.zsh-theme"
                ;;
            "fast-syntax-highlighting")
                [ -f "$plugin_dir/fast-syntax-highlighting.plugin.zsh" ] && source "$plugin_dir/fast-syntax-highlighting.plugin.zsh"
                ;;
            *)
                # Try to find and source any .zsh file
                for zsh_file in "$plugin_dir"/*.zsh(N); do
                    [ -f "$zsh_file" ] && source "$zsh_file"
                done
                ;;
        esac
    fi
done

# Helper functions for backward compatibility
add_plugin() {
    echo "${YELLOW}Note: add_plugin is deprecated. Use 'zsh-mgr add $1' instead${NO_COLOR}"
    zsh-mgr add "$1" ${2:+--flags="$2"}
}

add_plugin_private() {
    echo "${YELLOW}Note: add_plugin_private is deprecated. Use 'zsh-mgr add $1 --private' instead${NO_COLOR}"
    zsh-mgr add "$1" --private ${2:+--flags="$2"}
}

update_plugins() {
    echo "${YELLOW}Note: update_plugins is deprecated. Use 'zsh-mgr update' instead${NO_COLOR}"
    zsh-mgr update
}

# Auto-update check function
_auto_update_check() {
    local config_file="$HOME/.config/zsh/zsh-mgr/config.json"
    
    if [ ! -f "$config_file" ]; then
        return 0
    fi
    
    # Simple check without jq dependency
    local now=$(date +%s)
    
    # Check each plugin's timestamp
    for plugin_dir in "$ZSH_PLUGIN_DIR"/*; do
        if [ -d "$plugin_dir" ]; then
            local plugin_name=$(basename "$plugin_dir")
            local timestamp_file="$ZSH_PLUGIN_DIR/.$plugin_name"
            
            if [ -f "$timestamp_file" ]; then
                local last_update=$(cat "$timestamp_file" 2>/dev/null || echo "0")
                local next_update=$((last_update + TIME_THRESHOLD))
                
                if [ "$now" -ge "$next_update" ]; then
                    echo "${BRIGHT_CYAN}Auto-updating plugins...${NO_COLOR}"
                    zsh-mgr update --quiet 2>/dev/null || zsh-mgr update
                    break
                fi
            fi
        fi
    done
}

# Run auto-update check in background to avoid slowing down shell startup
(_auto_update_check &)

# Print helpful message on first run
if [ ! -f "$HOME/.config/zsh/zsh-mgr/.initialized" ]; then
    echo ""
    echo "${BRIGHT_CYAN}╔══════════════════════════════════════════════╗${NO_COLOR}"
    echo "${BRIGHT_CYAN}║   Welcome to zsh-mgr (Rust Edition)!        ║${NO_COLOR}"
    echo "${BRIGHT_CYAN}╚══════════════════════════════════════════════╝${NO_COLOR}"
    echo ""
    echo "Quick start:"
    echo "  ${GREEN}zsh-mgr add <user/repo>${NO_COLOR}    # Add a plugin"
    echo "  ${GREEN}zsh-mgr list${NO_COLOR}               # List installed plugins"
    echo "  ${GREEN}zsh-mgr update${NO_COLOR}             # Update all plugins"
    echo "  ${GREEN}zsh-mgr check${NO_COLOR}              # Check update status"
    echo "  ${GREEN}zsh-mgr --help${NO_COLOR}             # Show all commands"
    echo ""
    
    mkdir -p "$HOME/.config/zsh/zsh-mgr"
    touch "$HOME/.config/zsh/zsh-mgr/.initialized"
fi
