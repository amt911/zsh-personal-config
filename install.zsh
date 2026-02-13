#!/bin/zsh

# Symlinks MUST have ABSOLUTE PATH

# bash version
# ZSH_REPO_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# zsh version
readonly ZSH_REPO_PATH="$( cd -- "$( dirname -- "${(%):-%x}" )" &> /dev/null && pwd )"

# ── Determine the REAL home of the current user (by UID, not $HOME) ──
# sudo can preserve $HOME from the calling user, which causes us to
# operate on another user's directories.  We look up the passwd entry
# for our effective UID so we always target the right home.
_get_real_home() {
    local _rh
    _rh=$(getent passwd "$(id -u)" 2>/dev/null | cut -d: -f6)
    [ -n "$_rh" ] && echo "$_rh" || echo "$HOME"
}
readonly REAL_HOME="$(_get_real_home)"

# Which Powerlevel10k theme variant to use. It uses lean by default.
readonly P10K_VARIANT=${1:-"lean"}
p10k_file_name=".p10k.zsh"

[ "$P10K_VARIANT" = "rainbow" ] && p10k_file_name=".p10k.zsh_ALT"


# We manually create the folder in order to avoid copying 
# files to the repo and letting other plugins install on the same folder
# mkdir -p "$HOME/.config/zsh"
mkdir -p "$REAL_HOME/.zsh-plugins"

ln -sf "$ZSH_REPO_PATH/.zshrc" "$REAL_HOME/.zshrc"

ln -sf "$ZSH_REPO_PATH/$p10k_file_name" "$REAL_HOME/.p10k.zsh"

mkdir -p "$REAL_HOME/.config"
ln -sf "$ZSH_REPO_PATH/.config/zsh" "$REAL_HOME/.config/zsh"

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
        cd "$REAL_HOME/.config/zsh/zsh-mgr/zsh-mgr-rs"
        cargo build --release
        
        # Install binaries to ~/.local/bin
        mkdir -p "$REAL_HOME/.local/bin"
        cp target/release/zsh-mgr "$REAL_HOME/.local/bin/"
        
        # Add ~/.local/bin to PATH if not already there
        if [[ ":$PATH:" != *":$REAL_HOME/.local/bin:"* ]]; then
            export PATH="$REAL_HOME/.local/bin:$PATH"
        fi
        
        # Run install
        "$REAL_HOME/.local/bin/zsh-mgr" install --quiet
        
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

# Bootstrap plugins from .zshrc declarations (no default-plugins.txt needed)
# Reads 'plugin user/repo [flags...]' lines directly from .zshrc
if command -v zsh-mgr &> /dev/null; then
    echo ""
    echo "Installing plugins declared in .zshrc..."

    while IFS= read -r line; do
        # Extract repo (2nd field) and optional flags (remaining fields)
        _repo=$(echo "$line" | awk '{print $2}')
        _flags=$(echo "$line" | awk '{$1=$2=""; sub(/^[ \t]+/, ""); print}')

        _git_flags=""
        for _arg in ${=_flags}; do
            _git_flags="$_git_flags --$_arg"
        done
        _git_flags="${_git_flags## }"

        if [[ -n "$_git_flags" ]]; then
            zsh-mgr add "$_repo" --flags "$_git_flags"
        else
            zsh-mgr add "$_repo"
        fi
    done < <(grep -E '^\s*plugin\s+[a-zA-Z0-9_-]+/[a-zA-Z0-9._-]+' "$ZSH_REPO_PATH/.zshrc")

    echo ""
    echo "✓ Plugins installed"
fi

echo ""
echo "═══════════════════════════════════════"
echo "  Installation complete!"
echo "═══════════════════════════════════════"
echo ""
echo "Restart your terminal or run: source ~/.zshrc"