#!/bin/zsh

# fix-zsh-mgr-path.zsh - Arregla problemas de PATH con zsh-mgr

echo "╔══════════════════════════════════════════════╗"
echo "║  Fixing zsh-mgr PATH issues                  ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if binary exists in ~/.local/bin
if [ -f "$HOME/.local/bin/zsh-mgr" ]; then
    echo -e "${GREEN}✓ zsh-mgr binary found in ~/.local/bin${NC}"
    
    # Check if it's executable
    if [ -x "$HOME/.local/bin/zsh-mgr" ]; then
        echo -e "${GREEN}✓ Binary is executable${NC}"
    else
        echo -e "${YELLOW}⚠ Making binary executable...${NC}"
        chmod +x "$HOME/.local/bin/zsh-mgr"
        echo -e "${GREEN}✓ Done${NC}"
    fi
else
    echo -e "${RED}✗ zsh-mgr binary not found in ~/.local/bin${NC}"
    echo ""
    echo "Building zsh-mgr..."
    
    if ! command -v cargo &> /dev/null; then
        echo -e "${RED}✗ Cargo not found. Please install Rust first.${NC}"
        exit 1
    fi
    
    cd "$HOME/.config/zsh/zsh-mgr/zsh-mgr-rs"
    cargo build --release
    
    mkdir -p "$HOME/.local/bin"
    cp target/release/zsh-mgr "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/zsh-mgr"
    
    echo -e "${GREEN}✓ Built and installed successfully${NC}"
fi

echo ""

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    echo -e "${GREEN}✓ ~/.local/bin is in PATH${NC}"
else
    echo -e "${YELLOW}⚠ ~/.local/bin is NOT in PATH${NC}"
    echo ""
    echo "Adding to current session..."
    export PATH="$HOME/.local/bin:$PATH"
    echo -e "${GREEN}✓ Added to current session${NC}"
    echo ""
    echo -e "${CYAN}This will be persistent when you reload your shell (zsh-mgr-init.zsh handles it)${NC}"
fi

echo ""

# Test if zsh-mgr is now accessible
if command -v zsh-mgr &> /dev/null; then
    echo -e "${GREEN}✓ zsh-mgr is now accessible!${NC}"
    echo ""
    echo "Version:"
    zsh-mgr --version
    echo ""
    echo -e "${CYAN}You can now use:${NC}"
    echo "  zsh-mgr list"
    echo "  zsh-mgr check"
    echo "  zsh-mgr update"
else
    echo -e "${RED}✗ zsh-mgr still not accessible${NC}"
    echo ""
    echo "Manual steps:"
    echo "  1. Add this to your shell config:"
    echo "     export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
    echo "  2. Reload your shell:"
    echo "     source ~/.zshrc"
fi

echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║  Done!                                       ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "If you still have issues, run: source ~/.zshrc"
