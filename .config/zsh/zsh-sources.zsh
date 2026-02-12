#!/bin/zsh

# Source scripts. KEEP THIS ORDER!! It can break if it is loaded differently.
source $ZSH_CONFIG_DIR/zsh-exports.zsh
source $ZSH_CONFIG_DIR/zsh-mgr-init.zsh  # Initialize plugin manager (Rust)
source $ZSH_CONFIG_DIR/zshpc-functions.zsh
source $ZSH_CONFIG_DIR/zsh-aliases.zsh
source $ZSH_CONFIG_DIR/zsh-bindings.zsh
source $ZSH_CONFIG_DIR/zsh-styles.zsh