# zsh-personal-config

My personal ZSH configuration. Includes:

- Curated set of productivity plugins
- **[zsh-mgr](https://github.com/amt911/zsh-mgr) — my own plugin manager, fully written in Rust!**
- **Parallel Git updates** with real-time progress
- **Non-blocking auto-updates** (background, won't slow shell startup)
- **Auto-recovery** — `plugins.json` recreates itself if deleted (~19ms)
- **Explicit plugin control** — manual `plugin` declarations in `.zshrc`
- **Lazy auto-install** — missing plugins are cloned in the background on first load
- Beautiful aliases and styles (including colored `man` pages) from [Prezto](https://github.com/sorin-ionescu/prezto)

## Installation

### Quick Install

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc" \
  && git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main \
  && "$HOME/.zshpc/install.zsh"
```

This will:
1. Clone the repository with submodules (includes zsh-mgr source)
2. Create symlinks for `.zshrc`, `.p10k.zsh`, and `~/.config/zsh`
3. Detect if `zsh-mgr` is already installed via system package
4. If not, build from source with Cargo and install to `~/.local/bin`
5. Run `zsh-mgr install --quiet` (initial configuration)
6. Run `zsh-mgr bootstrap` (install default plugins from `default-plugins.txt`)
7. Run `zsh-mgr init` (generate plugin loading code in `.zshrc`)

<details>
<summary><b>Example installation output</b></summary>

```
═══════════════════════════════════════
  Installing zsh-mgr...
═══════════════════════════════════════
Building zsh-mgr from source...
   Compiling zsh-mgr-rs v0.1.0
    Finished `release` profile [optimized] target(s) in 12.34s

✓ zsh-mgr built and installed to ~/.local/bin

📝 NOTE: ~/.local/bin has been added to your PATH
   This will be persistent after reloading your shell

╔══════════════════════════════════════════════╗
║     ZSH Manager - Installation Wizard       ║
╚══════════════════════════════════════════════╝

ℹ️ .zshrc already configured

✓ zsh-mgr installed successfully!

📝 Next steps:
   1. Restart your terminal or run: source ~/.zshrc
   2. Add plugins: zsh-mgr add <user/repo>
   3. Check status: zsh-mgr check

Installing default plugins...
📋 Reading plugins from /home/user/.config/zsh/default-plugins.txt

Installing Aloxaf/fzf-tab
📦 Cloning Aloxaf/fzf-tab...
✓ Plugin 'Aloxaf/fzf-tab' installed successfully

Installing zsh-users/zsh-autosuggestions
📦 Cloning zsh-users/zsh-autosuggestions...
✓ Plugin 'zsh-users/zsh-autosuggestions' installed successfully

Installing zsh-users/zsh-history-substring-search
📦 Cloning zsh-users/zsh-history-substring-search...
✓ Plugin 'zsh-users/zsh-history-substring-search' installed successfully

Installing zdharma-continuum/fast-syntax-highlighting
📦 Cloning zdharma-continuum/fast-syntax-highlighting...
✓ Plugin 'zdharma-continuum/fast-syntax-highlighting' installed successfully

Installing zsh-users/zsh-completions
📦 Cloning zsh-users/zsh-completions...
✓ Plugin 'zsh-users/zsh-completions' installed successfully

Installing romkatv/powerlevel10k
📦 Cloning romkatv/powerlevel10k...
✓ Plugin 'romkatv/powerlevel10k' installed successfully

Installing amt911/zsh-useful-functions
📦 Cloning amt911/zsh-useful-functions...
✓ Plugin 'amt911/zsh-useful-functions' installed successfully

══════════════════════════════════════════════════
Bootstrap Summary
══════════════════════════════════════════════════
✓ Installed: 7
⚠ Skipped: 0
══════════════════════════════════════════════════

💡 Run 'zsh-mgr init' to update your .zshrc
✓ Default plugins installed

Generating .zshrc plugin loading code...
ℹ️ /home/user/.zshrc already has plugin calls

Current plugins in zsh-mgr:
  plugin Aloxaf/fzf-tab
  plugin zsh-users/zsh-autosuggestions
  plugin zsh-users/zsh-history-substring-search
  plugin zdharma-continuum/fast-syntax-highlighting
  plugin zsh-users/zsh-completions
  plugin romkatv/powerlevel10k
  plugin amt911/zsh-useful-functions

Options:
  1. Update manually in /home/user/.zshrc
  2. Or copy the lines above
✓ .zshrc updated with plugin loading code

═══════════════════════════════════════
  Installation complete!
═══════════════════════════════════════

Restart your terminal or run: source ~/.zshrc
```

</details>

### System Package Installation (Recommended)

If you install `zsh-mgr` from a package manager beforehand, the install script will detect it and skip the Cargo build step.

#### Arch Linux (AUR)
```console
yay -S zsh-mgr
```

#### Debian/Ubuntu
```console
wget https://github.com/amt911/zsh-mgr/releases/latest/download/zsh-mgr_amd64.deb
sudo dpkg -i zsh-mgr_amd64.deb
```

#### Fedora/RHEL
```console
wget https://github.com/amt911/zsh-mgr/releases/latest/download/zsh-mgr.rpm
sudo rpm -i zsh-mgr.rpm
```

Then run the config repo installer as usual:
```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc" \
  && git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main \
  && "$HOME/.zshpc/install.zsh"
```

### Installing with alternative terminal theme

There is an alternative Powerlevel10k theme (rainbow variant) that can be used instead of the default lean theme:

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc" \
  && git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main \
  && "$HOME/.zshpc/install.zsh" rainbow
```

### Manual Installation (from source)

If you prefer more control:

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc"
cd "$HOME/.zshpc/.config/zsh/zsh-mgr/zsh-mgr-rs"
cargo build --release
mkdir -p "$HOME/.local/bin"
cp target/release/zsh-mgr "$HOME/.local/bin/"
zsh-mgr install
zsh-mgr bootstrap
zsh-mgr init
```

## Updating

Update the config repository, the plugin manager, and all plugins with a single command:

```console
update_zshpc
```

This will:
1. `git pull` the `~/.zshpc` repository
2. `git pull` the `zsh-mgr` submodule
3. Rebuild `zsh-mgr` from source (only if not installed from a system package)
4. Run `zsh-mgr update` to update all plugins in parallel

## How it works

### Directory structure

```
~/.zshpc/                        # This repository (symlinked to ~/.zshrc)
├── .zshrc                       # Main ZSH config (symlinked to ~/.zshrc)
├── .p10k.zsh                    # Powerlevel10k theme (lean)
├── .p10k.zsh_ALT                # Powerlevel10k theme (rainbow)
├── install.zsh                  # Installation script
└── .config/zsh/                 # Symlinked to ~/.config/zsh
    ├── zsh-sources.zsh          # Master sourcing script (load order matters!)
    ├── zsh-exports.zsh          # Environment variables and ZSH options
    ├── zsh-mgr-init.zsh         # Plugin manager init (plugin/plugin_lazy functions)
    ├── zshpc-functions.zsh      # Custom functions (update_zshpc, ck_all, etc.)
    ├── zsh-aliases.zsh          # Aliases (git, yay, rsync, etc.)
    ├── zsh-bindings.zsh         # Key bindings
    ├── zsh-styles.zsh           # Completion styles (fzf-tab, Prezto)
    ├── default-plugins.txt      # Default plugins for bootstrap
    └── zsh-mgr/                 # zsh-mgr submodule (Rust source)

~/.zsh-plugins/                  # Where plugins are installed
├── Aloxaf/fzf-tab/
├── zsh-users/zsh-autosuggestions/
├── romkatv/powerlevel10k/
├── plugins.json                 # Plugin database (auto-recoverable)
└── ...
```

### Plugin loading

Plugins are declared **explicitly** in `.zshrc` using the `plugin` function:

```zsh
plugin romkatv/powerlevel10k depth=1
plugin zsh-users/zsh-completions
plugin Aloxaf/fzf-tab
plugin zsh-users/zsh-autosuggestions
```

- If a plugin is not installed, it is **automatically cloned in the background** (lazy auto-install). It will be available on the next shell restart.
- Optional git clone arguments can be passed inline: `depth=1`, `branch=dev`, `single-branch`.

For lazy loading (load a plugin only when a specific command is first invoked):

```zsh
plugin_lazy junegunn/fzf fzf
plugin_lazy sharkdp/bat bat
```

### Auto-update

On every shell startup, a background check runs non-blockingly:

1. Reads the timestamp of the last update from `~/.zsh-plugins/.zsh-mgr-last-update`
2. If more than `TIME_THRESHOLD` seconds have passed, runs `zsh-mgr update` in the background
3. A desktop notification is sent when the update completes (if `notify-send` is available)

This **never slows down shell startup** — the check and update happen in a detached background process.

## Configuration variables

The following environment variables control the behavior of the auto-update system. They are defined in `~/.config/zsh/zsh-exports.zsh` and can be overridden:

| Variable | Default | Description |
|---|---|---|
| `TIME_THRESHOLD` | `604800` (1 week) | Interval in seconds between automatic plugin updates. Used by both the auto-update function in `zsh-mgr-init.zsh` and by `zsh-mgr check` to determine update status. |
| `MGR_TIME_THRESHOLD` | `604800` (1 week) | Interval in seconds between automatic updates of `zsh-mgr` itself. |
| `ZSHPC_TIME_THRESHOLD` | `604800` (1 week) | Reserved for future use (zsh-personal-config self-update threshold). Currently defined but not used. |
| `ZSH_PLUGIN_DIR` | `~/.zsh-plugins` | Directory where plugins are cloned to. |
| `ZSH_CONFIG_DIR` | `~/.config/zsh` | Directory containing all ZSH configuration scripts. |
| `FZF_DIR_FILE_LOC` | `/usr/share/fzf/` | Path to fzf shell integration files. Automatically set to `/usr/share/doc/fzf/examples` on Ubuntu. |

### Changing the auto-update interval

Edit `~/.config/zsh/zsh-exports.zsh`:

```zsh
export TIME_THRESHOLD=86400       # Update plugins daily (24h)
export MGR_TIME_THRESHOLD=1209600 # Update zsh-mgr every 2 weeks
```

Common values:
| Interval | Seconds |
|---|---|
| 1 day | `86400` |
| 3 days | `259200` |
| 1 week | `604800` |
| 2 weeks | `1209600` |
| 1 month | `2592000` |

## Plugin manager (zsh-mgr)

This configuration uses [zsh-mgr](https://github.com/amt911/zsh-mgr) — a modern, fast plugin manager written entirely in Rust. See the [zsh-mgr README](https://github.com/amt911/zsh-mgr) for full standalone usage documentation.

### Quick reference

```console
zsh-mgr add <user/repo>                   # Add a plugin
zsh-mgr add <user/repo> --flags="--depth 1"  # Add with git clone flags
zsh-mgr add <user/repo> --private         # Add private repo (SSH)
zsh-mgr update                            # Update all plugins (parallel)
zsh-mgr update --only plugin1 --only plugin2  # Update specific plugins
zsh-mgr check                             # Check next update dates
zsh-mgr list                              # List installed plugins
zsh-mgr remove <plugin-name>              # Remove a plugin
zsh-mgr bootstrap                         # Install plugins from default-plugins.txt
zsh-mgr init                              # Generate plugin loading code for .zshrc
zsh-mgr sync                              # Rebuild plugins.json from installed repos
```

### Useful shell functions

| Function | Description |
|---|---|
| `update_zshpc` | Update the config repo, zsh-mgr, and all plugins |
| `ck_all` | Show plugin and manager update status (`zsh-mgr check`) |
| `re` | Reload `.zshrc` (`source ~/.zshrc`) |

## Default plugins

| Plugin | Description |
|---|---|
| [romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k) | Fast, flexible prompt theme |
| [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions) | Additional completion definitions |
| [Aloxaf/fzf-tab](https://github.com/Aloxaf/fzf-tab) | Replace zsh completion menu with fzf |
| [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Fish-like autosuggestions |
| [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search) | Fish-like history search |
| [zdharma-continuum/fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting) | Syntax highlighting (must be loaded last) |
| [amt911/zsh-useful-functions](https://github.com/amt911/zsh-useful-functions) | Custom utility functions |

## Dependencies

| Package | Required | Description |
|---|---|---|
| zsh | ✅ | Shell |
| git | ✅ | Plugin cloning and updates |
| **zsh-mgr** | ✅ | Plugin manager (from package or built from source) |
| lsd | ❌ | Better `ls` (used in aliases and fzf-tab preview) |
| fzf | ❌ | Fuzzy finder (key bindings + tab completion) |
| notify-send | ❌ | Desktop notifications for background updates |

### Build dependencies (only if building from source)

- `cargo` / `rustc` (Rust toolchain)

## Finding bugs

If you encounter a bug, please open an issue or create a pull request to solve it. I speak both Spanish and English.
