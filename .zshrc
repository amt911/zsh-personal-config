# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Launch the completer
autoload -U compinit
compinit

export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Source all scripts
source $ZSH_CONFIG_DIR/zsh-sources.zsh

# ═══════════════════════════════════════════════════════════════════
# PLUGINS - Declaración explícita y ordenada
# ═══════════════════════════════════════════════════════════════════
# Sintaxis: plugin user/repo
# Gestión:  zsh-mgr {add|remove|update|list}
#
# Los plugins se instalan automáticamente si no existen (lazy install)
# Usa plugin_lazy para cargar solo cuando se necesite (ver ejemplos abajo)
# ═══════════════════════════════════════════════════════════════════

# Core plugins (siempre activos)
plugin romkatv/powerlevel10k
plugin Aloxaf/fzf-tab
plugin zsh-users/zsh-autosuggestions
plugin zsh-users/zsh-history-substring-search
plugin zdharma-continuum/fast-syntax-highlighting
plugin zsh-users/zsh-completions
plugin amt911/zsh-useful-functions

# ═══════════════════════════════════════════════════════════════════
# LAZY LOADING (opcional - descomenta para usar)
# ═══════════════════════════════════════════════════════════════════
# Carga plugins solo cuando ejecutas comandos específicos
# Sintaxis: plugin_lazy user/repo comando1 comando2 ...
#
# Ejemplos:
# plugin_lazy junegunn/fzf fzf
# plugin_lazy dbrgn/tealdeer tldr
# plugin_lazy sharkdp/bat bat
# ═══════════════════════════════════════════════════════════════════

# Only loads fzf's autocompletion if it is installed
if check_cmd_exists "fzf"; then
  source "$FZF_DIR_FILE_LOC/key-bindings.zsh"
  source "$FZF_DIR_FILE_LOC/completion.zsh"
fi


# Man parser for tab completion on unsupported commands
compdef _gnu_generic nvidia-smi grub-install fc-cache userdel passwd ntfsfix fdupes bc test

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh