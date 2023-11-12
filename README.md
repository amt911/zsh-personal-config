# zsh-personal-config

This is my personal zsh config. It includes the following:

- Some default plugins that I like.
- A very primitive plugin manager.
- Some aliases and styles (including man coloring). Some of these styles are extracted from Prezto.

## Installation

Use the following command to clone the repository and install the files;

```console
git clone --recurse-submodules --remote-submodules git@github.com:amt911/zsh-personal-config.git "$HOME/.zshpc" && $HOME/.zshpc/install.zsh
```

Alternatively, you can run both commands separately, like this:

```console
git clone --recurse-submodules --remote-submodules git@github.com:amt911/zsh-personal-config.git "$HOME/.zshpc"
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

In order to add a plugin, you can do it like this:

```
add_plugin "author/plugin-name"
```

And if you need extra git flags, you can do it like this other way:

```
add_plugin "author/plugin-name" "--flag1 --flag2"
```

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

If you encounter a bug, please open an issue or create a pull request to solve it.
