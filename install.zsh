#!/bin/zsh

# Symlinks MUST have ABSOLUTE PATH

# bash version
# ZSH_REPO_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# zsh version
readonly ZSH_REPO_PATH="$( cd -- "$( dirname -- "${(%):-%x}" )" &> /dev/null && pwd )"

# Which Powerlevel10k theme variant to use. It uses lean by default.
readonly P10K_VARIANT=${1:-"lean"}
p10k_file_name=".p10k.zsh"

[ "$P10K_VARIANT" -eq "rainbow" ] && p10k_file_name=".p10k.zsh_ALT"


# We manually create the folder in order to avoid copying 
# files to the repo and letting other plugins install on the same folder
# mkdir -p "$HOME/.config/zsh"
mkdir -p "$HOME/.zsh-plugins"

ln -sf "$ZSH_REPO_PATH/.zshrc" "$HOME/.zshrc"



ln -sf "$ZSH_REPO_PATH/$p10k_file_name" "$HOME/.p10k.zsh"

mkdir -p "$HOME/.config"
ln -sf "$ZSH_REPO_PATH/.config/zsh" "$HOME/.config/zsh"