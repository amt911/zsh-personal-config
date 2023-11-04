#!/bin/zsh

# Symlinks MUST have ABSOLUTE PATH

# bash version
# ZSH_REPO_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# zsh version
ZSH_REPO_PATH="$( cd -- "$( dirname -- "${(%):-%x}" )" &> /dev/null && pwd )"

# We manually create the folder in order to avoid copying 
# files to the repo and letting other plugins install on the same folder
mkdir -p "$HOME/.config/zsh"

ln -sf "$ZSH_REPO_PATH/.zshrc" "$HOME/.zshrc"
ln -sf "$ZSH_REPO_PATH/.p10k.zsh" "$HOME/.p10k.zsh"

for i in "$ZSH_REPO_PATH"/.config/zsh/*; do
    [[ -e "$i" ]] || break

    aux=$(echo "$i" | grep -o "[^/]*$")
    ln -sf "$i" "$HOME/.config/zsh/$aux"
done