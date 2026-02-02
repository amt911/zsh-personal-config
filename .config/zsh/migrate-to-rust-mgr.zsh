#!/bin/zsh

# migrate-to-rust-mgr.zsh - Migra plugins del antiguo sistema al nuevo

set -e

echo "╔══════════════════════════════════════════════╗"
echo "║  Migration to Rust-based zsh-mgr            ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if zsh-mgr is available
if ! command -v zsh-mgr &> /dev/null; then
    echo -e "${RED}✗ zsh-mgr not found${NC}"
    echo ""
    echo "Please install zsh-mgr first:"
    echo "  1. System package (recommended):"
    echo "     - Arch: yay -S zsh-mgr"
    echo "     - Debian/Ubuntu: Install .deb from releases"
    echo ""
    echo "  2. Build from source:"
    echo "     cd ~/.config/zsh/zsh-mgr/zsh-mgr-rs"
    echo "     cargo build --release"
    echo "     make install PREFIX=\$HOME/.local"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ zsh-mgr found${NC}"
echo ""

# List of default plugins from old .zshrc
PLUGINS=(
    "Aloxaf/fzf-tab"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-history-substring-search"
    "zdharma-continuum/fast-syntax-highlighting"
    "zsh-users/zsh-completions"
    "romkatv/powerlevel10k"
    "amt911/zsh-useful-functions"
)

PLUGIN_FLAGS=(
    ""
    ""
    ""
    ""
    ""
    "--depth=1"
    ""
)

echo -e "${CYAN}Plugins to migrate:${NC}"
for i in {1..${#PLUGINS[@]}}; do
    plugin="${PLUGINS[$i]}"
    flags="${PLUGIN_FLAGS[$i]}"
    if [ -n "$flags" ]; then
        echo "  - $plugin (flags: $flags)"
    else
        echo "  - $plugin"
    fi
done
echo ""

# Check if already migrated
if [ -f "$HOME/.config/zsh/zsh-mgr/.migrated" ]; then
    echo -e "${YELLOW}⚠ Migration already completed${NC}"
    echo ""
    read "confirm?Do you want to re-run migration? [y/N] "
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Migration cancelled"
        exit 0
    fi
fi

echo -e "${CYAN}Detecting existing plugins...${NC}"
echo ""

# Detect existing plugins in ~/.zsh-plugins/
EXISTING_PLUGINS=()
for dir in "$HOME/.zsh-plugins/"*/; do
    if [ -d "$dir" ]; then
        plugin_name=$(basename "$dir")
        # Skip hidden directories (like .git)
        if [[ ! "$plugin_name" =~ ^\. ]]; then
            EXISTING_PLUGINS+=("$plugin_name")
        fi
    fi
done

if [ ${#EXISTING_PLUGINS[@]} -eq 0 ]; then
    echo -e "${YELLOW}No existing plugins found in ~/.zsh-plugins/${NC}"
    echo ""
    echo "Would you like to install the default plugins? [y/N]"
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        # Install mode
        echo -e "${CYAN}Installing default plugins...${NC}"
        echo ""
        
        migrated=0
        failed=0
        
        for i in {1..${#PLUGINS[@]}}; do
            plugin="${PLUGINS[$i]}"
            flags="${PLUGIN_FLAGS[$i]}"
            
            echo -e "${CYAN}[$i/${#PLUGINS[@]}] Installing: $plugin${NC}"
            
            if [ -n "$flags" ]; then
                if zsh-mgr add "$plugin" $flags; then
                    echo -e "${GREEN}  ✓ Installed${NC}"
                    ((migrated++))
                else
                    echo -e "${RED}  ✗ Failed${NC}"
                    ((failed++))
                fi
            else
                if zsh-mgr add "$plugin"; then
                    echo -e "${GREEN}  ✓ Installed${NC}"
                    ((migrated++))
                else
                    echo -e "${RED}  ✗ Failed${NC}"
                    ((failed++))
                fi
            fi
            echo ""
        done
    else
        echo "Installation cancelled"
        exit 0
    fi
else
    echo -e "${GREEN}Found ${#EXISTING_PLUGINS[@]} existing plugins:${NC}"
    for plugin in "${EXISTING_PLUGINS[@]}"; do
        echo "  - $plugin"
    done
    echo ""
    
    echo -e "${CYAN}Registering existing plugins with zsh-mgr...${NC}"
    echo ""
    
    # Map plugin names to their repos
    declare -A PLUGIN_MAP
    PLUGIN_MAP[fzf-tab]="Aloxaf/fzf-tab"
    PLUGIN_MAP[zsh-autosuggestions]="zsh-users/zsh-autosuggestions"
    PLUGIN_MAP[zsh-history-substring-search]="zsh-users/zsh-history-substring-search"
    PLUGIN_MAP[fast-syntax-highlighting]="zdharma-continuum/fast-syntax-highlighting"
    PLUGIN_MAP[zsh-completions]="zsh-users/zsh-completions"
    PLUGIN_MAP[powerlevel10k]="romkatv/powerlevel10k"
    PLUGIN_MAP[zsh-useful-functions]="amt911/zsh-useful-functions"
    
    migrated=0
    skipped=0
    failed=0
    
    for plugin_dir in "${EXISTING_PLUGINS[@]}"; do
        # Find the repo URL
        repo="${PLUGIN_MAP[$plugin_dir]}"
        
        if [ -z "$repo" ]; then
            echo -e "${YELLOW}⚠ Unknown plugin: $plugin_dir (skipping)${NC}"
            ((skipped++))
            continue
        fi
        
        echo -e "${CYAN}Registering: $plugin_dir → $repo${NC}"
        
        # Create plugins.json entry manually using jq or direct creation
        plugin_path="$HOME/.zsh-plugins/$plugin_dir"
        
        # Just create a simple registration using zsh-mgr's internal format
        # Since the plugin is already installed, we just need to register it in plugins.json
        
        # For now, we'll use zsh-mgr add with --skip-clone flag if available
        # Or we manually create the plugins.json
        
        # Check if zsh-mgr supports registration of existing plugins
        # For simplicity, we'll create the entry manually
        
        config_file="$HOME/.config/zsh/plugins.json"
        
        # Create or update plugins.json
        if [ ! -f "$config_file" ]; then
            echo '{"plugins":[]}' > "$config_file"
        fi
        
        # Add entry using jq if available, otherwise skip
        if command -v jq &> /dev/null; then
            temp_file=$(mktemp)
            jq --arg name "$plugin_dir" --arg repo "$repo" --arg path "$plugin_path" \
                '.plugins += [{"name": $name, "repo": $repo, "path": $path}]' \
                "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
            echo -e "${GREEN}  ✓ Registered${NC}"
            ((migrated++))
        else
            echo -e "${YELLOW}  ⚠ jq not found, manual registration needed${NC}"
            ((skipped++))
        fi
        echo ""
    done
fi

# Create migration marker
mkdir -p "$HOME/.config/zsh/zsh-mgr"
touch "$HOME/.config/zsh/zsh-mgr/.migrated"

# Summary
echo "╔══════════════════════════════════════════════╗"
echo "║  Migration Summary                           ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo -e "Total plugins: ${#PLUGINS[@]}"
echo -e "${GREEN}Migrated: $migrated${NC}"
echo -e "${YELLOW}Skipped: $skipped${NC}"
echo -e "${RED}Failed: $failed${NC}"
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}✓ Migration completed successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Check installed plugins: zsh-mgr list"
    echo "  3. View update status: zsh-mgr check"
    echo ""
else
    echo -e "${YELLOW}⚠ Migration completed with some errors${NC}"
    echo ""
    echo "Please manually install failed plugins:"
    echo "  zsh-mgr add <user/repo>"
    echo ""
fi

echo "Useful commands:"
echo "  zsh-mgr list     # List all plugins"
echo "  zsh-mgr update   # Update all plugins"
echo "  zsh-mgr check    # Check update status"
echo "  zsh-mgr --help   # Show all commands"
echo ""
