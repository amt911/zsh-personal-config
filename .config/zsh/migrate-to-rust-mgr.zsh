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

echo -e "${CYAN}Starting migration...${NC}"
echo ""

# Migrate each plugin
migrated=0
skipped=0
failed=0

for i in {1..${#PLUGINS[@]}}; do
    plugin="${PLUGINS[$i]}"
    flags="${PLUGIN_FLAGS[$i]}"
    
    echo -e "${CYAN}[$i/${#PLUGINS[@]}] Processing: $plugin${NC}"
    
    # Check if already installed
    plugin_dir="$HOME/.zsh-plugins/$plugin"
    if [ -d "$plugin_dir" ]; then
        echo -e "${YELLOW}  ⚠ Already exists, skipping${NC}"
        ((skipped++))
    else
        # Install with zsh-mgr
        if [ -n "$flags" ]; then
            if zsh-mgr add "$plugin" --flags="$flags"; then
                echo -e "${GREEN}  ✓ Installed successfully${NC}"
                ((migrated++))
            else
                echo -e "${RED}  ✗ Installation failed${NC}"
                ((failed++))
            fi
        else
            if zsh-mgr add "$plugin"; then
                echo -e "${GREEN}  ✓ Installed successfully${NC}"
                ((migrated++))
            else
                echo -e "${RED}  ✗ Installation failed${NC}"
                ((failed++))
            fi
        fi
    fi
    echo ""
done

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
