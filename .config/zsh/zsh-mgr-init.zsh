#!/bin/zsh

# zsh-mgr-init.zsh - Explicit plugin loading with lazy loading support
# Part of zsh-mgr: A Rust-based ZSH plugin manager

if [ "$ZSH_MGR_INIT" != yes ]; then
    ZSH_MGR_INIT=yes
else
    return 0
fi

# Color definitions
export BRIGHT_CYAN='\033[1;36m'
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export YELLOW='\033[1;33m'
export NO_COLOR='\033[0m'

# Add ~/.local/bin to PATH if it exists and not already in PATH
if [ -d "$HOME/.local/bin" ] && [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Check if zsh-mgr is installed
if ! command -v zsh-mgr &> /dev/null; then
    echo "${RED}Error: zsh-mgr not found in PATH${NO_COLOR}" >&2
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
    
    local plugin_name="${repo##*/}"  # Extrae el nombre del repo (después del último /)
    # El directorio puede ser user/repo o solo repo (compatibilidad con instalaciones antiguas)
    local plugin_dir="$ZSH_PLUGIN_DIR/$repo"
    if [ ! -d "$plugin_dir" ]; then
        # Intentar con solo el nombre del plugin (formato antiguo)
        plugin_dir="$ZSH_PLUGIN_DIR/$plugin_name"
    fi
    
    # Si el plugin no está instalado, instalarlo automáticamente (lazy install)
    if [ ! -d "$plugin_dir" ]; then
        echo "${YELLOW}⚡ Installing $plugin_name...${NO_COLOR}" >&2
        
        # Construir comando con argumentos
        # zsh-mgr usa --flags para pasar argumentos a git clone
        # Convertir argumentos al formato correcto
        if [ ${#plugin_args[@]} -gt 0 ]; then
            local git_flags=""
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
            
            # Ejecutar directamente sin eval
            if zsh-mgr add "$repo" --flags "$git_flags" >/dev/null 2>&1; then
                echo "${GREEN}✓ Installed $plugin_name${NO_COLOR}" >&2
            else
                echo "${RED}✗ Failed to install $plugin_name${NO_COLOR}" >&2
                echo "${YELLOW}Try manually: zsh-mgr add '$repo' --flags '$git_flags'${NO_COLOR}" >&2
                return 1
            fi
        else
            # Sin argumentos adicionales
            if zsh-mgr add "$repo" >/dev/null 2>&1; then
                echo "${GREEN}✓ Installed $plugin_name${NO_COLOR}" >&2
            else
                echo "${RED}✗ Failed to install $plugin_name${NO_COLOR}" >&2
                return 1
            fi
        fi
        
        # Actualizar plugin_dir después de la instalación
        # zsh-mgr siempre instala en user/repo
        plugin_dir="$ZSH_PLUGIN_DIR/$repo"
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
            # Agregar al fpath y retornar
            fpath=("$plugin_dir/src" $fpath)
            autoload -U compinit && compinit
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
            echo "${YELLOW}Warning: Failed to load $plugin_name${NO_COLOR}" >&2
            return 1
        }
    else
        echo "${YELLOW}Warning: No loadable file found for $plugin_name${NO_COLOR}" >&2
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
        echo \"${RED}Error: $trigger not found after loading $repo${NO_COLOR}\" >&2
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
    local threshold="${MGR_TIME_THRESHOLD:-604800}"  # Default: 1 semana (604800s)
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
        # Subshell para aislar completamente
        (
            # Actualizar plugins silenciosamente
            zsh-mgr update &>/dev/null
            
            # Guardar timestamp
            date +%s > "$timestamp_file" 2>/dev/null
            
            # Notificación opcional (si notify-send está disponible)
            if command -v notify-send &>/dev/null; then
                notify-send -i terminal "zsh-mgr" "Plugins updated successfully" 2>/dev/null
            fi
        ) &
        
        # Disown para que no aparezca en jobs
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
    echo "${YELLOW}⚠ Deprecated: load_plugin() is now plugin()${NO_COLOR}" >&2
    echo "${YELLOW}  Update your .zshrc: load_plugin '$1' -> plugin 'user/$1'${NO_COLOR}" >&2
    plugin "$1"
}

# Backward compatibility: add_plugin
add_plugin() {
    echo "${YELLOW}⚠ Deprecated: Use 'zsh-mgr add $1' instead${NO_COLOR}" >&2
    zsh-mgr add "$1" ${2:+--flags="$2"}
}

# Backward compatibility: add_plugin_private
add_plugin_private() {
    echo "${YELLOW}⚠ Deprecated: Use 'zsh-mgr add $1 --private' instead${NO_COLOR}" >&2
    zsh-mgr add "$1" --private ${2:+--flags="$2"}
}

# Helper: update all plugins
update_plugins() {
    echo "${YELLOW}⚠ Deprecated: Use 'zsh-mgr update' directly${NO_COLOR}" >&2
    zsh-mgr update
}

# Auto-update check function (non-blocking, runs in background)
_auto_update_check() {
    local threshold="${MGR_TIME_THRESHOLD:-604800}"
    local timestamp_file="$ZSH_PLUGIN_DIR/.zsh-mgr"
    
    # Check if enough time has passed
    if [ -f "$timestamp_file" ]; then
        local last_update=$(cat "$timestamp_file" 2>/dev/null || echo 0)
        local now=$(date +%s)
        local diff=$((now - last_update))
        
        if [ $diff -lt $threshold ]; then
            return 0
        fi
    fi
    
    # Update plugins in background without blocking shell startup
    # Use a subshell with full detachment
    (
        {
            local log_file="$ZSH_PLUGIN_DIR/.update-log"
            zsh-mgr update > "$log_file" 2>&1
            
            # Update timestamp on success
            if [ $? -eq 0 ]; then
                date +%s > "$timestamp_file"
                
                # Optional: Send notification when done (if notify-send is available)
                if command -v notify-send &> /dev/null; then
                    notify-send "zsh-mgr" "Plugins updated successfully"
                fi
            fi
        } &
    ) &>/dev/null
    
    # Disown the background job so it's not killed when shell exits
    disown &>/dev/null
}

# Trigger auto-update check in background (won't block shell startup)
_auto_update_check &!

# Print helpful message on first run
if [ ! -f "$HOME/.config/zsh/zsh-mgr/.initialized" ]; then
    echo ""
    echo "${BRIGHT_CYAN}╔══════════════════════════════════════════════╗${NO_COLOR}"
    echo "${BRIGHT_CYAN}║   Welcome to zsh-mgr (Rust Edition)!        ║${NO_COLOR}"
    echo "${BRIGHT_CYAN}╚══════════════════════════════════════════════╝${NO_COLOR}"
    echo ""
    echo "Quick start:"
    echo "  ${GREEN}zsh-mgr add <user/repo>${NO_COLOR}    # Add a plugin"
    echo "  ${GREEN}zsh-mgr list${NO_COLOR}               # List installed plugins"
    echo "  ${GREEN}zsh-mgr update${NO_COLOR}             # Update all plugins"
    echo "  ${GREEN}zsh-mgr check${NO_COLOR}              # Check update status"
    echo "  ${GREEN}zsh-mgr --help${NO_COLOR}             # Show all commands"
    echo ""
    
    mkdir -p "$HOME/.config/zsh/zsh-mgr"
    touch "$HOME/.config/zsh/zsh-mgr/.initialized"
fi
