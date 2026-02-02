#!/bin/zsh

# Symlinks MUST have ABSOLUTE PATH

# bash version
# ZSH_REPO_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# zsh version
readonly ZSH_REPO_PATH="$( cd -- "$( dirname -- "${(%):-%x}" )" &> /dev/null && pwd )"

# Which Powerlevel10k theme variant to use. It uses lean by default.
readonly P10K_VARIANT=${1:-"lean"}
p10k_file_name=".p10k.zsh"

[ "$P10K_VARIANT" = "rainbow" ] && p10k_file_name=".p10k.zsh_ALT"


# We manually create the folder in order to avoid copying 
# files to the repo and letting other plugins install on the same folder
# mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.zsh-plugins"

ln -sf "$ZSH_REPO_PATH/.zshrc" "$HOME/.zshrc"

ln -sf "$ZSH_REPO_PATH/$p10k_file_name" "$HOME/.p10k.zsh"

mkdir -p "$HOME/.config"
ln -sf "$ZSH_REPO_PATH/.config/zsh" "$HOME/.config/zsh"

# Check if zsh-mgr is installed via package manager
check_system_zsh_mgr() {
    if command -v zsh-mgr &> /dev/null; then
        local zsh_mgr_path=$(which zsh-mgr)
        if [[ "$zsh_mgr_path" == "/usr/bin/zsh-mgr" || "$zsh_mgr_path" == "/usr/local/bin/zsh-mgr" ]]; then
            echo "✓ zsh-mgr detected from system package"
            return 0
        fi
    fi
    return 1
}

# Install or build zsh-mgr
install_zsh_mgr() {
    echo ""
    echo "═══════════════════════════════════════"
    echo "  Installing zsh-mgr..."
    echo "═══════════════════════════════════════"
    
    if check_system_zsh_mgr; then
        echo "Using system-installed zsh-mgr"
        zsh-mgr install --quiet
    elif command -v cargo &> /dev/null; then
        echo "Building zsh-mgr from source..."
        cd "$HOME/.config/zsh/zsh-mgr/zsh-mgr-rs"
        cargo build --release
        
        # Install binaries to ~/.local/bin
        mkdir -p "$HOME/.local/bin"
        cp target/release/zsh-mgr "$HOME/.local/bin/"
        
        # Add ~/.local/bin to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
        fi
        
        # Run install
        "$HOME/.local/bin/zsh-mgr" install --quiet
        
        echo ""
        echo "✓ zsh-mgr built and installed to ~/.local/bin"
        echo ""
        echo "📝 NOTE: ~/.local/bin has been added to your PATH"
        echo "   This will be persistent after reloading your shell"
    else
        echo "⚠️  Neither system package nor Rust found"
        echo ""
        echo "To install zsh-mgr, either:"
        echo "  1. Install the system package for your distribution:"
        echo "     - Arch Linux: yay -S zsh-mgr"
        echo "     - Debian/Ubuntu: Download and install .deb from releases"
        echo "     - Fedora/RHEL: Download and install .rpm from releases"
        echo ""
        echo "  2. Install Rust and rebuild:"
        echo "     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        echo ""
        echo "Skipping zsh-mgr installation for now."
        return 1
    fi
}

# Install zsh-mgr
install_zsh_mgr

# Bootstrap default plugins
if command -v zsh-mgr &> /dev/null && [ -f "$HOME/.config/zsh/default-plugins.txt" ]; then
    echo ""
    echo "Installing default plugins..."
    if zsh-mgr bootstrap; then
        echo "✓ Default plugins installed"
        
        # Generate .zshrc plugin loading code
        echo ""
        echo "Generating .zshrc plugin loading code..."
        if zsh-mgr init; then
            echo "✓ .zshrc updated with plugin loading code"
        fi
    fi
fi

echo ""
echo "═══════════════════════════════════════"
echo "  Installation complete!"
echo "═══════════════════════════════════════"
echo ""
echo "Restart your terminal or run: source ~/.zshrc"