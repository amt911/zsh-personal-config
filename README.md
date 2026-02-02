# zsh-personal-config

This is my personal zsh config. It includes the following:

- Some plugins that I like.
- **My own plugin manager [zsh-mgr](https://github.com/amt911/zsh-mgr) - now fully written in Rust!**
- **Parallel Git updater with real-time progress**
- Some aliases and styles (including man coloring). Some of these styles are extracted from [Prezto](https://github.com/sorin-ionescu/prezto).

## Installation

### Quick Install

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc" && git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main && $HOME/.zshpc/install.zsh
```

This will:
1. Clone the repository
2. Initialize submodules
3. Detect if zsh-mgr is installed via package manager
4. If not, build from source (requires Rust) or skip if not available

### System Package Installation (Recommended)

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

After installing the package, run:
```console
zsh-mgr install
```

### Manual Installation

If you prefer to build from source:

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc"
cd "$HOME/.zshpc/.config/zsh/zsh-mgr/zsh-mgr-rs"
cargo build --release
make install PREFIX=$HOME/.local
zsh-mgr install
```

### Installing with alternative terminal theme

There is an alternative theme which can be used in place of the default one:

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc" && git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main && $HOME/.zshpc/install.zsh rainbow
```

## Migrating from Old Version

If you're upgrading from the old shell-based zsh-mgr to the new Rust version, run the migration script:

```console
~/.config/zsh/migrate-to-rust-mgr.zsh
```

This will:
1. Check if zsh-mgr is installed
2. Migrate all your existing plugins to the new system
3. Preserve plugin configurations and flags
4. Create a backup marker to avoid re-migration

After migration, restart your terminal or run:
```console
source ~/.zshrc
```

## Updating

In order to update the repository, you can do it with the following command:

```console
update_zshpc
```

It will update this repository and the plugin manager.

## Plugin manager (zsh-mgr)

This configuration uses [zsh-mgr](https://github.com/amt911/zsh-mgr) - a modern, fast plugin manager written entirely in Rust.

### Features

- ✅ **Parallel updates** - Update all plugins simultaneously
- ✅ **Real-time progress** - See what's happening with each plugin
- ✅ **Automatic management** - Auto-updates on schedule
- ✅ **Clean CLI** - Simple, intuitive commands
- ✅ **Fast** - Written in Rust for maximum performance
- ✅ **Smart detection** - Works with system packages or local builds

### Usage

#### Add a plugin
```console
zsh-mgr add zsh-users/zsh-autosuggestions
```

#### Add with custom flags
```console
zsh-mgr add zsh-users/zsh-syntax-highlighting --flags="--depth=1"
```

#### Add private repository
```console
zsh-mgr add your-user/private-repo --private
```

#### Update all plugins
```console
zsh-mgr update
```

#### Update specific plugins
```console
zsh-mgr update --only plugin1 --only plugin2
```

#### Check next update dates
```console
zsh-mgr check
```

Output example:
```
╔════════════════════════════════════════════════════════════╗
║ Name                    │ Next Update        │ Status      ║
╠════════════════════════════════════════════════════════════╣
║ zsh-autosuggestions     │ 2024-01-30 10:00   │ ✓ Current   ║
║ zsh-syntax-highlighting │ 2024-01-29 15:30   │ ⏰ Soon     ║
║ powerlevel10k           │ 2024-01-25 08:00   │ ⚠ Update   ║
╚════════════════════════════════════════════════════════════╝
```

#### List installed plugins
```console
zsh-mgr list
```

#### Remove a plugin
```console
zsh-mgr remove plugin-name
```

## Dependencies

This repository depends on the following packages:

- zsh
- git
- **zsh-mgr** (from package manager or build from Rust)
- lsd (optional, for better `ls`)
- fzf (optional, for fuzzy finding)
- bc (optional)

### Build Dependencies (only if building from source)

- cargo/rustc (Rust toolchain)
- zsh

## Finding bugs

If you encounter a bug, please open an issue or create a pull request to solve it. I speak both spanish and english.
