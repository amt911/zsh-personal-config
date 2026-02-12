# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Source all scripts
source $ZSH_CONFIG_DIR/zsh-sources.zsh

# ═══════════════════════════════════════════════════════════════════
# PLUGINS - Declaración explícita y ordenada
# ═══════════════════════════════════════════════════════════════════
# Sintaxis: plugin user/repo [args...]
# Gestión:  zsh-mgr {add|remove|update|list}
#
# Argumentos opcionales (se pasan a git clone):
#   depth=1         - Clone superficial (recomendado para temas grandes)
#   branch=nombre   - Branch específico
#   single-branch   - Solo el branch especificado
#   
# Los plugins se instalan automáticamente si no existen (lazy install)
# Usa plugin_lazy para cargar solo cuando se necesite (ver ejemplos abajo)
# ═══════════════════════════════════════════════════════════════════

# Theme (debe cargarse primero para instant prompt)
plugin romkatv/powerlevel10k depth=1

# Completions (añade al fpath, ANTES de compinit)
plugin zsh-users/zsh-completions

# Inicializar compinit UNA SOLA VEZ (con caché diaria para rendimiento)
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
fi

# Core plugins (fzf-tab necesita compinit, por eso va después)
plugin Aloxaf/fzf-tab
plugin zsh-users/zsh-autosuggestions
plugin zsh-users/zsh-history-substring-search
plugin amt911/zsh-useful-functions

# Syntax highlighting SIEMPRE al final (hooks into ZLE)
plugin zdharma-continuum/fast-syntax-highlighting

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