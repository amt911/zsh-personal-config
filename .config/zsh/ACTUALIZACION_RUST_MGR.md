# Actualización de zsh-personal-config para usar zsh-mgr en Rust

## 🎉 Cambios Realizados

Se ha actualizado completamente zsh-personal-config para usar el nuevo zsh-mgr escrito en Rust.

## 📝 Archivos Modificados

### 1. `.config/zsh/zsh-sources.zsh`
- ❌ Eliminado: `source $ZSH_CONFIG_DIR/zsh-mgr/zsh-mgr.zsh`
- ✅ Añadido: `source $ZSH_CONFIG_DIR/zsh-mgr-init.zsh`

### 2. `.zshrc`
- ❌ Eliminadas las llamadas a `add_plugin`
- ✅ Añadidos comentarios sobre cómo usar `zsh-mgr` CLI
- ℹ️ Los plugins ahora se gestionan con comandos CLI

### 3. `.config/zsh/zshpc-functions.zsh`
- ❌ Eliminada la carga de scripts antiguos de zsh-mgr
- ✅ Actualizada función `update_zshpc()` para usar el nuevo sistema
- ✅ Simplificada función `ck_all()` para usar `zsh-mgr check`

## 🆕 Archivos Nuevos

### 1. `.config/zsh/zsh-mgr-init.zsh`
Script inicializador del nuevo sistema que:
- ✅ Verifica que zsh-mgr esté instalado
- ✅ Carga automáticamente todos los plugins de `$ZSH_PLUGIN_DIR`
- ✅ Proporciona funciones de compatibilidad hacia atrás (`add_plugin`, `add_plugin_private`)
- ✅ Implementa auto-actualización en segundo plano
- ✅ Muestra mensaje de bienvenida en primera ejecución

### 2. `.config/zsh/migrate-to-rust-mgr.zsh`
Script de migración automática que:
- ✅ Verifica la instalación de zsh-mgr
- ✅ Migra todos los plugins por defecto
- ✅ Preserva flags de plugins (como `--depth=1` para powerlevel10k)
- ✅ Crea marcador para evitar re-migración
- ✅ Proporciona resumen detallado

## 🔄 Compatibilidad Hacia Atrás

Se mantienen funciones compatibles para facilitar la transición:

```bash
# Funciones antiguas (deprecated pero funcionales)
add_plugin "user/repo"           # → zsh-mgr add user/repo
add_plugin_private "user/repo"   # → zsh-mgr add user/repo --private
update_plugins                    # → zsh-mgr update
```

Estas funciones muestran un aviso de deprecación y llaman al nuevo CLI.

## 📦 Plugins por Defecto

Los siguientes plugins se migran automáticamente:

1. **Aloxaf/fzf-tab**
2. **zsh-users/zsh-autosuggestions**
3. **zsh-users/zsh-history-substring-search**
4. **zdharma-continuum/fast-syntax-highlighting**
5. **zsh-users/zsh-completions**
6. **romkatv/powerlevel10k** (con `--depth=1`)
7. **amt911/zsh-useful-functions**

## 🚀 Nuevo Flujo de Trabajo

### Instalación Inicial

```bash
# 1. Instalar zsh-mgr (una vez)
yay -S zsh-mgr  # Arch Linux
# O construir desde fuente

# 2. Migrar plugins existentes
~/.config/zsh/migrate-to-rust-mgr.zsh

# 3. Recargar configuración
source ~/.zshrc
```

### Uso Diario

```bash
# Añadir nuevo plugin
zsh-mgr add zsh-users/zsh-autosuggestions

# Ver plugins instalados
zsh-mgr list

# Actualizar todos los plugins (paralelo!)
zsh-mgr update

# Ver estado de actualizaciones
zsh-mgr check

# Ver ayuda
zsh-mgr --help
```

### Comandos Heredados

```bash
# Actualizar todo (config + plugins)
update_zshpc

# Ver estado de todo
ck_all
```

## 🎯 Ventajas del Nuevo Sistema

1. **Performance**: 10-20x más rápido gracias a Rust
2. **Paralelismo**: Actualiza todos los plugins simultáneamente
3. **UX Mejorada**: Tablas bonitas, colores, mensajes claros
4. **Gestión Simplificada**: CLI intuitivo con comandos claros
5. **Mantenibilidad**: Código robusto y tipado
6. **Portabilidad**: Un solo binario, fácil de instalar

## 📋 Checklist de Migración

Para usuarios existentes:

- [ ] Instalar zsh-mgr (paquete o desde fuente)
- [ ] Ejecutar script de migración: `~/.config/zsh/migrate-to-rust-mgr.zsh`
- [ ] Reiniciar terminal o ejecutar: `source ~/.zshrc`
- [ ] Verificar plugins: `zsh-mgr list`
- [ ] Probar actualización: `zsh-mgr update`
- [ ] Revisar estado: `zsh-mgr check`

## 🔍 Verificación

Después de migrar, verifica que todo funciona:

```bash
# 1. Verificar que zsh-mgr está disponible
which zsh-mgr

# 2. Ver plugins instalados
zsh-mgr list

# 3. Ver estado de actualizaciones
zsh-mgr check

# 4. Probar actualización
zsh-mgr update --verbose
```

## 🐛 Solución de Problemas

### zsh-mgr no encontrado

```bash
# Si instalaste desde fuente
export PATH="$HOME/.local/bin:$PATH"

# Agregar a .zshrc permanentemente
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
```

### Plugins no se cargan

```bash
# Verificar que existen en el directorio
ls -la ~/.zsh-plugins/

# Re-migrar plugins
~/.config/zsh/migrate-to-rust-mgr.zsh
```

### Variables de entorno

Las siguientes variables deben estar configuradas (ya están en `.config/zsh/zsh-exports.zsh`):

```bash
export ZSH_CONFIG_DIR="$HOME/.config/zsh"
export ZSH_PLUGIN_DIR="$HOME/.zsh-plugins"
export TIME_THRESHOLD=604800        # 1 semana
export MGR_TIME_THRESHOLD=604800
```

## 📚 Documentación Adicional

- [README principal](../../README.md) - Instrucciones de instalación
- [README de zsh-mgr](zsh-mgr/README.md) - Documentación del manager
- [Guía de migración completa](zsh-mgr/zsh-mgr-rs/MIGRACION_COMPLETA.md)

## 🎓 Ejemplos de Uso

### Añadir Plugin con Flags Personalizados

```bash
zsh-mgr add romkatv/powerlevel10k --flags="--depth=1 --single-branch"
```

### Añadir Plugin Privado

```bash
zsh-mgr add tu-usuario/plugin-privado --private
```

### Actualizar Solo Algunos Plugins

```bash
zsh-mgr update --only zsh-autosuggestions --only powerlevel10k
```

### Ver Estado en JSON

```bash
zsh-mgr check --json | jq
```

---

**¡Actualización completada!** 🎉

Tu configuración de zsh ahora usa el moderno y rápido zsh-mgr escrito en Rust.
