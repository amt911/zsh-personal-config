#!/bin/zsh

# zsh-mgr-init.zsh - Auto-load plugins and manage updates automatically
# Part of zsh-mgr: A Rust-based ZSH plugin manager

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

# Function to intelligently load a plugin
_load_plugin() {
    local plugin_name="$1"
    local plugin_dir
    
    # Check flat structure first
    if [ -d "$ZSH_PLUGIN_DIR/$plugin_name" ]; then
        plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"
    else
        # Check nested structure (user/repo) - using find to avoid glob expansion issues
        local found_dir=$(find "$ZSH_PLUGIN_DIR" -maxdepth 2 -type d -name "$plugin_name" 2>/dev/null | head -n 1)
        if [ -n "$found_dir" ]; then
            plugin_dir="$found_dir"
        fi
    fi
    
    if [ -z "$plugin_dir" ]; then
        echo "${RED}Error: Plugin '$plugin_name' not found in $ZSH_PLUGIN_DIR${NO_COLOR}" >&2
        return 1
    fi
    
    # Find and source the appropriate plugin file
    local plugin_file=""
    
    # Special handling for specific plugins
    case "$plugin_name" in
        "powerlevel10k")
            plugin_file="$plugin_dir/powerlevel10k.zsh-theme"
            ;;
        "fast-syntax-highlighting")
            plugin_file="$plugin_dir/fast-syntax-highlighting.plugin.zsh"
            ;;
        "zsh-useful-functions")
            plugin_file="$plugin_dir/zsh-useful-functions.zsh"
            ;;
        *)
            # Try .plugin.zsh first
            if [ -f "$plugin_dir/$plugin_name.plugin.zsh" ]; then
                plugin_file="$plugin_dir/$plugin_name.plugin.zsh"
            # Try any .plugin.zsh file
            elif [ -n "$(find "$plugin_dir" -maxdepth 1 -name '*.plugin.zsh' 2>/dev/null | head -1)" ]; then
                plugin_file="$(find "$plugin_dir" -maxdepth 1 -name '*.plugin.zsh' 2>/dev/null | head -1)"
            # Fall back to .zsh-theme
            elif [ -f "$plugin_dir/$plugin_name.zsh-theme" ]; then
                plugin_file="$plugin_dir/$plugin_name.zsh-theme"
            # Fall back to main .zsh file
            elif [ -f "$plugin_dir/$plugin_name.zsh" ]; then
                plugin_file="$plugin_dir/$plugin_name.zsh"
            fi
            ;;
    esac
    
    # Source the plugin file if found
    if [ -n "$plugin_file" ] && [ -f "$plugin_file" ]; then
        # Using builtin source to preserve $0 context
        builtin source "$plugin_file" 2>/dev/null || {
            echo "${YELLOW}Warning: Failed to load plugin '$plugin_name'${NO_COLOR}" >&2
        }
    else
        echo "${YELLOW}Warning: No suitable file found for plugin '$plugin_name'${NO_COLOR}" >&2
    fi
}

# Auto-load all plugins from zsh-mgr
# This must run in global scope to preserve $0 context for plugins
if command -v zsh-mgr &> /dev/null 2>&1; then
    # Get list of plugins
    _zsh_mgr_plugins=($(zsh-mgr list --names-only 2>/dev/null))
    
    for _zsh_mgr_plugin in "${_zsh_mgr_plugins[@]}"; do
        # Find plugin directory
        _zsh_mgr_plugin_dir=""
        if [ -d "$ZSH_PLUGIN_DIR/$_zsh_mgr_plugin" ]; then
            _zsh_mgr_plugin_dir="$ZSH_PLUGIN_DIR/$_zsh_mgr_plugin"
        else
            _zsh_mgr_plugin_dir=$(find "$ZSH_PLUGIN_DIR" -maxdepth 2 -type d -name "$_zsh_mgr_plugin" 2>/dev/null | head -n 1)
        fi
        
        if [ -z "$_zsh_mgr_plugin_dir" ]; then
            continue
        fi
        
        # Find and source the appropriate plugin file
        _zsh_mgr_plugin_file=""
        case "$_zsh_mgr_plugin" in
            "powerlevel10k")
                _zsh_mgr_plugin_file="$_zsh_mgr_plugin_dir/powerlevel10k.zsh-theme"
                ;;
            "fast-syntax-highlighting")
                _zsh_mgr_plugin_file="$_zsh_mgr_plugin_dir/fast-syntax-highlighting.plugin.zsh"
                ;;
            "zsh-useful-functions")
                _zsh_mgr_plugin_file="$_zsh_mgr_plugin_dir/zsh-useful-functions.zsh"
                ;;
            *)
                # Try .plugin.zsh first
                if [ -f "$_zsh_mgr_plugin_dir/$_zsh_mgr_plugin.plugin.zsh" ]; then
                    _zsh_mgr_plugin_file="$_zsh_mgr_plugin_dir/$_zsh_mgr_plugin.plugin.zsh"
                elif [ -f "$_zsh_mgr_plugin_dir/$_zsh_mgr_plugin.zsh-theme" ]; then
                    _zsh_mgr_plugin_file="$_zsh_mgr_plugin_dir/$_zsh_mgr_plugin.zsh-theme"
                elif [ -f "$_zsh_mgr_plugin_dir/$_zsh_mgr_plugin.zsh" ]; then
                    _zsh_mgr_plugin_file="$_zsh_mgr_plugin_dir/$_zsh_mgr_plugin.zsh"
                else
                    # Find any .plugin.zsh file
                    _zsh_mgr_plugin_file=$(find "$_zsh_mgr_plugin_dir" -maxdepth 1 -name '*.plugin.zsh' 2>/dev/null | head -1)
                fi
                ;;
        esac
        
        # Source the plugin file if found
        if [ -n "$_zsh_mgr_plugin_file" ] && [ -f "$_zsh_mgr_plugin_file" ]; then
            source "$_zsh_mgr_plugin_file" 2>/dev/null
        fi
    done
    
    # Clean up temporary variables
    unset _zsh_mgr_plugins _zsh_mgr_plugin _zsh_mgr_plugin_dir _zsh_mgr_plugin_file
fi

# Auto-update check (non-blocking, background)
_auto_update_check() {
    local threshold="${MGR_TIME_THRESHOLD:-604800}"  # Default: 1 week
    local timestamp_file="$ZSH_PLUGIN_DIR/.last-auto-update"
    
    # Create plugin dir if it doesn't exist
    [ ! -d "$ZSH_PLUGIN_DIR" ] && mkdir -p "$ZSH_PLUGIN_DIR"
    
    if [[ -f "$timestamp_file" ]]; then
        local last_update=$(cat "$timestamp_file" 2>/dev/null || echo "0")
        local now=$(date +%s)
        local diff=$((now - last_update))
        
        if [[ $diff -lt $threshold ]]; then
            return 0
        fi
    fi
    
    # Update in background (non-blocking)
    # This runs silently and doesn't interrupt the shell startup
    (
        zsh-mgr update &>/dev/null && date +%s > "$timestamp_file"
    ) &!
}

# Execute auto-update in background
_auto_update_check &!

# Deprecated legacy function for backward compatibility
load_plugin() {
    echo "${YELLOW}Warning: load_plugin is deprecated. Plugins are auto-loaded from zsh-mgr.${NO_COLOR}" >&2
    echo "Manage plugins with: zsh-mgr {add|remove|update|list}${NO_COLOR}" >&2
    _load_plugin "$1"
}

# Deprecated helper functions
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
