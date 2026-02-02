#!/bin/zsh

# zsh-mgr-init.zsh - Explicit plugin loading with lazy loading support
# Part of zsh-mgr: A Rust-based ZSH plugin manager

if [ "$ZSH_MGR_INIT" != yes ]; then
    ZSH_MGR_INIT=yes
else
    return 0
fi

# Color definitions (NOT exported to avoid NO_COLOR convention killing colors
# in child processes like lazygit, fzf, etc. See https://no-color.org/)
BRIGHT_CYAN='\033[1;36m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET_COLOR='\033[0m'

# Add ~/.local/bin to PATH if it exists and not already in PATH
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Check if zsh-mgr is installed
if ! command -v zsh-mgr &> /dev/null; then
    echo "${RED}Error: zsh-mgr not found in PATH${RESET_COLOR}" >&2
    echo "Install with: yay -S zsh-mgr" >&2
    echo "Or: cd ~/.config/zsh/zsh-mgr/zsh-mgr-rs && cargo build --release && cp target/release/zsh-mgr ~/.local/bin/" >&2
    return 1
fi

# ════════════════════════════════════════════════════════════════
# FUNCIÓN PRINCIPAL: plugin
# Carga explícita de plugins (sintaxis: plugin user/repo [args...])
# ════════════════════════════════════════════════════════════════

plugin() {
    local repo="$1"
    shift
    local plugin_args=("$@")  # Argumentos adicionales (depth=1, branch=dev, etc.)
    
    # Validación básica
    if [[ ! "$repo" =~ ^[^/]+/[^/]+$ ]]; then
        echo "${RED}✗ Invalid format: $repo${RESET_COLOR}" >&2
        echo "${YELLOW}  Expected: user/repo${RESET_COLOR}" >&2
        return 1
    fi
    
    local plugin_name="${repo##*/}"  # Extrae el nombre del repo (después del último /)
    local plugin_dir="$ZSH_PLUGIN_DIR/$repo"
    
    # ✅ FIX: Verificar AMBAS estructuras (nueva: user/repo, antigua: plugin_name)
    local old_plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"
    
    # Si existe en estructura antigua, usar esa
    if [ -d "$old_plugin_dir" ] && [ ! -d "$plugin_dir" ]; then
        plugin_dir="$old_plugin_dir"
    fi
    
    # Si el plugin no está instalado EN NINGUNA ESTRUCTURA
    if [ ! -d "$plugin_dir" ]; then
        # ✅ FIX: Silenciar completamente los jobs en background
        {
            (
                local git_flags=""
                
                # Procesar argumentos opcionales
                for arg in "${plugin_args[@]}"; do
                    # Convertir depth=1 -> --depth=1, branch=name -> --branch=name, etc.
                    if [[ "$arg" == *=* ]]; then
                        git_flags="$git_flags --$arg"
                    else
                        # Argumentos sin valor (ej: single-branch)
                        git_flags="$git_flags --$arg"
                    fi
                done
                # Remover espacio inicial
                git_flags="${git_flags# }"
                
                # Ejecutar en background - la salida va a un log temporal
                local log_file="${TMPDIR:-/tmp}/zsh-mgr-install-${plugin_name}.log"
                
                if [[ -n "$git_flags" ]]; then
                    zsh-mgr add "$repo" --flags "$git_flags" >"$log_file" 2>&1
                else
                    zsh-mgr add "$repo" >"$log_file" 2>&1
                fi
                
                if [[ $? -eq 0 ]]; then
                    rm -f "$log_file"
                fi
            ) &
        } &>/dev/null
        
        # ✅ FIX: Disown inmediatamente para evitar mensajes
        disown &>/dev/null
        
        # El plugin estará disponible en el próximo reinicio
        return 0
    fi
    
    # Determinar qué archivo cargar (optimizado con case para plugins conocidos)
    local plugin_file=""
    
    case "$plugin_name" in
        powerlevel10k)
            plugin_file="$plugin_dir/powerlevel10k.zsh-theme"
            ;;
        fast-syntax-highlighting)
            plugin_file="$plugin_dir/fast-syntax-highlighting.plugin.zsh"
            ;;
        fzf-tab)
            plugin_file="$plugin_dir/fzf-tab.plugin.zsh"
            ;;
        zsh-autosuggestions)
            plugin_file="$plugin_dir/zsh-autosuggestions.zsh"
            ;;
        zsh-history-substring-search)
            plugin_file="$plugin_dir/zsh-history-substring-search.zsh"
            ;;
        zsh-completions)
            # Este plugin solo añade completions, no tiene archivo .zsh principal
            # Agregar al fpath y retornar (compinit se llama una sola vez desde .zshrc)
            fpath=("$plugin_dir/src" $fpath)
            return 0
            ;;
        zsh-useful-functions)
            plugin_file="$plugin_dir/zsh-useful-functions.zsh"
            ;;
        *)
            # Búsqueda genérica para plugins desconocidos
            if [ -f "$plugin_dir/$plugin_name.plugin.zsh" ]; then
                plugin_file="$plugin_dir/$plugin_name.plugin.zsh"
            elif [ -f "$plugin_dir/$plugin_name.zsh" ]; then
                plugin_file="$plugin_dir/$plugin_name.zsh"
            elif [ -f "$plugin_dir/$plugin_name.zsh-theme" ]; then
                plugin_file="$plugin_dir/$plugin_name.zsh-theme"
            else
                # Último recurso: buscar en subdirectorios
                plugin_file=$(find "$plugin_dir" -maxdepth 2 \( -name '*.plugin.zsh' -o -name '*.zsh-theme' \) -print -quit 2>/dev/null)
            fi
            ;;
    esac
    
    # Source del plugin
    if [ -n "$plugin_file" ] && [ -f "$plugin_file" ]; then
        builtin source "$plugin_file" 2>/dev/null || {
            echo "${YELLOW}Warning: Failed to load $plugin_name${RESET_COLOR}" >&2
            return 1
        }
    else
        echo "${YELLOW}Warning: No loadable file found for $plugin_name${RESET_COLOR}" >&2
        return 1
    fi
}

# ════════════════════════════════════════════════════════════════
# LAZY LOADING: plugin_lazy
# Carga el plugin solo cuando se invoca un comando específico
# ════════════════════════════════════════════════════════════════

plugin_lazy() {
    local repo="$1"
    shift
    local triggers=("$@")
    
    # Si no hay triggers, carga inmediatamente
    if [ ${#triggers[@]} -eq 0 ]; then
        plugin "$repo"
        return
    fi
    
    # Crear funciones stub para cada trigger
    for trigger in "${triggers[@]}"; do
        eval "
$trigger() {
    # Remove stub function
    unfunction $trigger 2>/dev/null
    
    # Load the plugin
    plugin $repo
    
    # Execute the real command
    if command -v $trigger &>/dev/null; then
        $trigger \"\$@\"
    else
        echo \"${RED}Error: $trigger not found after loading $repo${RESET_COLOR}\" >&2
        return 127
    fi
}
        "
    done
}

# ════════════════════════════════════════════════════════════════
# AUTO-UPDATE (background, completamente no bloqueante)
# ════════════════════════════════════════════════════════════════

_zsh_mgr_auto_update() {
    local threshold="${TIME_THRESHOLD:-604800}"  # Usa TIME_THRESHOLD (mismo que zsh-mgr check)
    local timestamp_file="$ZSH_PLUGIN_DIR/.zsh-mgr-last-update"
    
    # Crear directorio si no existe
    [ ! -d "$ZSH_PLUGIN_DIR" ] && mkdir -p "$ZSH_PLUGIN_DIR"
    
    # Verificar si es necesario actualizar
    if [ -f "$timestamp_file" ]; then
        local last_update=$(cat "$timestamp_file" 2>/dev/null || echo 0)
        local now=$(date +%s)
        local diff=$((now - last_update))
        
        # Si aún no ha pasado el threshold, no hacer nada
        if [ $diff -lt $threshold ]; then
            return 0
        fi
    fi
    
    # Ejecutar actualización en segundo plano (completamente detached)
    {
        (
            local log_file="$ZSH_PLUGIN_DIR/.update-log"
            # Unset NO_COLOR para que zsh-mgr muestre colores en el log
            unset NO_COLOR
            zsh-mgr update > "$log_file" 2>&1
            
            if [ $? -eq 0 ]; then
                # Guardar timestamp en ambos archivos para compatibilidad
                date +%s > "$timestamp_file" 2>/dev/null
                date +%s > "$ZSH_PLUGIN_DIR/.zsh-mgr" 2>/dev/null
                
                # Limpiar cache de p10k tras actualizar (evita errores de gitstatus
                # por dump obsoleto cuando se actualiza powerlevel10k)
                rm -f ~/.cache/p10k-dump-*.zsh{,.zwc} 2>/dev/null
                rm -f ~/.cache/p10k-instant-prompt-*.zsh{,.zwc} 2>/dev/null
                
                if command -v notify-send &>/dev/null; then
                    notify-send -i terminal "zsh-mgr" "Plugins updated successfully" 2>/dev/null
                fi
            fi
        ) &
        disown &>/dev/null
    } &>/dev/null
}

# Trigger auto-update check (no bloqueante)
_zsh_mgr_auto_update &!

# ════════════════════════════════════════════════════════════════
# FUNCIONES DE COMPATIBILIDAD (deprecated)
# ════════════════════════════════════════════════════════════════

# Backward compatibility: load_plugin -> plugin
load_plugin() {
    # Silently convert to new format - NO warnings during shell init
    local plugin_name="$1"
    
    # Try to find the full repo name in plugins.json
    local full_repo=""
    if [[ -f "$ZSH_CONFIG_DIR/zsh-mgr/plugins.json" ]]; then
        # Extract repo name that ends with /$plugin_name
        full_repo=$(jq -r --arg name "$plugin_name" '.plugins[] | select(.name | endswith("/" + $name)) | .name' "$ZSH_CONFIG_DIR/zsh-mgr/plugins.json" 2>/dev/null | head -1)
    fi
    
    # Fallback: try to detect from installed directories
    if [[ -z "$full_repo" ]]; then
        # Search in ZSH_PLUGIN_DIR for matching directory
        for dir in "$ZSH_PLUGIN_DIR"/*/*/"$plugin_name"(N); do
            # Extract user/repo from path
            full_repo="${dir#$ZSH_PLUGIN_DIR/}"
            full_repo="${full_repo%/$plugin_name}"
            break
        done
    fi
    
    # If we found the full repo name, use it
    if [[ -n "$full_repo" ]]; then
        plugin "$full_repo"
    else
        # Last resort: show error but don't block
        echo "${RED}✗ Cannot find plugin: $plugin_name${RESET_COLOR}" >&2
        echo "${YELLOW}  Try: plugin 'user/$plugin_name'${RESET_COLOR}" >&2
    fi
}

# Backward compatibility: add_plugin
add_plugin() {
    echo "${YELLOW}⚠ Deprecated: Use 'zsh-mgr add $1' instead${RESET_COLOR}" >&2
    zsh-mgr add "$1" ${2:+--flags="$2"}
}

# Backward compatibility: add_plugin_private
add_plugin_private() {
    echo "${YELLOW}⚠ Deprecated: Use 'zsh-mgr add $1 --private' instead${RESET_COLOR}" >&2
    zsh-mgr add "$1" --private ${2:+--flags="$2"}
}

# Helper: update all plugins
update_plugins() {
    echo "${YELLOW}⚠ Deprecated: Use 'zsh-mgr update' directly${RESET_COLOR}" >&2
    zsh-mgr update
}

# Print helpful message on first run
if [ ! -f "$HOME/.config/zsh/zsh-mgr/.initialized" ]; then
    echo ""
    echo "${BRIGHT_CYAN}╔══════════════════════════════════════════════╗${RESET_COLOR}"
    echo "${BRIGHT_CYAN}║   Welcome to zsh-mgr (Rust Edition)!        ║${RESET_COLOR}"
    echo "${BRIGHT_CYAN}╚══════════════════════════════════════════════╝${RESET_COLOR}"
    echo ""
    echo "Quick start:"
    echo "  ${GREEN}zsh-mgr add <user/repo>${RESET_COLOR}    # Add a plugin"
    echo "  ${GREEN}zsh-mgr list${RESET_COLOR}               # List installed plugins"
    echo "  ${GREEN}zsh-mgr update${RESET_COLOR}             # Update all plugins"
    echo "  ${GREEN}zsh-mgr check${RESET_COLOR}              # Check update status"
    echo "  ${GREEN}zsh-mgr --help${RESET_COLOR}             # Show all commands"
    echo ""
    
    mkdir -p "$HOME/.config/zsh/zsh-mgr"
    touch "$HOME/.config/zsh/zsh-mgr/.initialized"
fi
