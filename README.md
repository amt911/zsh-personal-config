# zsh-personal-config

This is my personal zsh config. It includes the following:

- Some plugins that I like.
- My own plugin manager [zsh-mgr](https://github.com/amt911/zsh-mgr)
- Some aliases and styles (including man coloring). Some of these styles are extracted from [Prezto](https://github.com/sorin-ionescu/prezto).

## Installation

Use the following command to clone the repository and install the files;

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc" && git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main && $HOME/.zshpc/install.zsh
```

Alternatively, you can run both commands separately, like this:

```console
git clone --recurse-submodules https://github.com/amt911/zsh-personal-config.git "$HOME/.zshpc"
```

```console
git -C "$HOME/.zshpc" submodule foreach --recursive git checkout main
```

```console
$HOME/.zshpc/install.zsh
```

## Updating

In order to update the repository, you can do it with the following command:

```console
update_zshpc
```

It will update this repository and the plugin manager.

## Plugin manager (zsh-mgr)

This configuration uses [zsh-mgr](https://github.com/amt911/zsh-mgr) as the plugin manager. It auto-updates the plugins every week.

The following examples are also included in ```zsh-mgr```:

To add a plugin, you can do it like this:

```
add_plugin "author/plugin-name"
```

If you need extra git flags, you can do it like this other way:

```
add_plugin "author/plugin-name" "--flag1 --flag2"
```

To add a plugin from a private repo, you need to write:

```
add_plugin_private "author/plugin-name"
```

```add_plugin_private``` also supports optional flags, like ```add_plugin```.

There is also a manual updater in order to check for updates. The command is:

```console
update_plugins
```

To see the plugins, zsh-mgr and zshpc update date, input the following command:

```console
ck_all
```

## Dependencies

This repository depends on the following packages:

- bc
- sed
- fzf
- lsd
- awk
- cut
- date
- git
- echo
- zsh

## Finding bugs

If you encounter a bug, please open an issue or create a pull request to solve it. I can speak both spanish and english.
