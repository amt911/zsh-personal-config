# zsh-personal-config

This is my personal zsh config. It includes the following:

- Some default plugins that I like.
- A very primitive plugin manager.
- Some aliases and styles (including man coloring). Some of these styles are extracted from Prezto.

## Installation

Use the following command to clone the repository and install the files;

```console
git clone git@github.com:amt911/zsh-personal-config.git "$HOME/.zshpc" && $HOME/.zshpc/install
```

Alternatively, you can run both commands separately, like this:

```console
git clone git@github.com:amt911/zsh-personal-config.git "$HOME/.zshpc"
```

```console
$HOME/.zshpc/install
```

## Updating

In order to update the repository, you can do it with the following command:

```console
update_zshpc
```

## Plugin manager (zsh-mgr)

My plugin manager (named "zsh-mgr") is a very primitive and very lightly tested plugin manager. The most notable feature is that it updates plugins every week automatically.

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


## Finding bugs

If you encounter a bug, please open an issue or create a pull request to solve it.
