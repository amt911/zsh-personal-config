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

# Function to load a specific plugin
load_plugin() {
    local plugin_name="$1"
    local plugin_dir
    
    # Check flat structure first
    if [ -d "$ZSH_PLUGIN_DIR/$plugin_name" ]; then
        plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"
    else
        # Check nested structure (user/repo) - using find to avoid glob expansion issues
        local found_dir=$(find "$ZSH_PLUGIN_DIR" -maxdepth 2 -type d -name "$plugin_name" | head -n 1)
        if [ -n "$found_dir" ]; then
            plugin_dir="$found_dir"
        fi
    fi
    
    if [ -z "$plugin_dir" ]; then
        echo "${RED}Error: Plugin '$plugin_name' not found in $ZSH_PLUGIN_DIR${NO_COLOR}"
        return 1
    fi
    
    # Special handling for specific plugins
    case "$plugin_name" in
        "powerlevel10k")
            [ -f "$plugin_dir/powerlevel10k.zsh-theme" ] && source "$plugin_dir/powerlevel10k.zsh-theme"
            ;;
        "fast-syntax-highlighting")
            [ -f "$plugin_dir/fast-syntax-highlighting.plugin.zsh" ] && source "$plugin_dir/fast-syntax-highlighting.plugin.zsh"
            ;;
        "zsh-useful-functions")
            # This plugin uses .zsh extension, not .plugin.zsh
            [ -f "$plugin_dir/zsh-useful-functions.zsh" ] && source "$plugin_dir/zsh-useful-functions.zsh"
            ;;
        *)
            # Try .plugin.zsh first
            if [ -f "$plugin_dir/$plugin_name.plugin.zsh" ]; then
                source "$plugin_dir/$plugin_name.plugin.zsh"
            # Try any .plugin.zsh file
            elif compgen -G "$plugin_dir/*.plugin.zsh" > /dev/null; then
                for plugin_file in "$plugin_dir"/*.plugin.zsh; do
                    source "$plugin_file"
                done
            # Fall back to any .zsh file
            else
                if compgen -G "$plugin_dir/*.zsh" > /dev/null; then
                    for zsh_file in "$plugin_dir"/*.zsh; do
                        [ -f "$zsh_file" ] && source "$zsh_file"
                    done
                fi
            fi
            ;;
    esac
}

# Note: Plugins must be loaded manually in .zshrc
# Use: load_plugin "plugin-name"
# Example:
#   load_plugin "fzf-tab"
#   load_plugin "zsh-autosuggestions"

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

# Auto-update check function (non-blocking, runs in background)
_auto_update_check() {
    local threshold="${MGR_TIME_THRESHOLD:-604800}"
    local timestamp_file="$ZSH_PLUGIN_DIR/.zsh-mgr"
    
    # Check if enough time has passed
    if [ -f "$timestamp_file" ]; then
        local last_update=$(cat "$timestamp_file" 2>/dev/null || echo 0)
        local now=$(date +%s)
        local diff=$((now - last_update))
        
        if [ $diff -lt $threshold ]; then
            return 0
        fi
    fi
    
    # Update plugins in background without blocking shell startup
    # Use a subshell with full detachment
    (
        {
            local log_file="$ZSH_PLUGIN_DIR/.update-log"
            zsh-mgr update > "$log_file" 2>&1
            
            # Update timestamp on success
            if [ $? -eq 0 ]; then
                date +%s > "$timestamp_file"
                
                # Optional: Send notification when done (if notify-send is available)
                if command -v notify-send &> /dev/null; then
                    notify-send "zsh-mgr" "Plugins updated successfully"
                fi
            fi
        } &
    ) &>/dev/null
    
    # Disown the background job so it's not killed when shell exits
    disown &>/dev/null
}

# Trigger auto-update check in background (won't block shell startup)
_auto_update_check &!

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
