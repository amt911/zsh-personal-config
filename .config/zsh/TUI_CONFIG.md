# Terminal UI (TUI) Configuration Guide

This guide covers configuration for TUI applications like lazygit, htop, and others to display correctly with full color support.

## Color Support Configuration

The zsh-personal-config automatically configures the following environment variables for optimal TUI support:

```bash
export TERM="xterm-256color"
export COLORTERM="truecolor"
```

These are set in [zsh-exports.zsh](zsh-exports.zsh) and provide:
- **256-color support** for most TUI applications
- **24-bit truecolor** support for modern applications

## lazygit Configuration

A default configuration for lazygit is provided in `~/.config/lazygit/config.yml` with:

- ✨ **Color theme** optimized for terminal environments
- 🎨 **Syntax highlighting** with delta integration
- 🖱️ **Mouse support** enabled
- ⌨️ **Vim-style keybindings** (h/j/k/l navigation)
- 🔄 **Auto-refresh** and auto-fetch enabled
- 🎯 **Rounded borders** for better visual appearance

### Testing lazygit colors

After applying the configuration:

1. Open a new terminal or run `exec zsh`
2. Navigate to any git repository
3. Run `lazygit`

You should see:
- Colored diffs (green for additions, red for deletions)
- Blue selection highlighting
- Cyan borders on active panels
- Proper syntax highlighting in file previews

### Troubleshooting

If colors still don't appear:

1. **Verify terminal emulator support**:
   ```bash
   # Test 24-bit color support
   printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
   ```
   You should see orange text.

2. **Check environment variables**:
   ```bash
   echo $TERM        # Should be: xterm-256color
   echo $COLORTERM   # Should be: truecolor
   ```

3. **Verify terminal emulator settings**:
   - Some terminals need explicit 24-bit color support enabled
   - Examples: iTerm2, Alacritty, Kitty, WezTerm support it by default
   - GNOME Terminal, Konsole: enable in preferences

4. **Test with different pager**:
   If using delta (recommended), install it:
   ```bash
   # Arch Linux
   sudo pacman -S git-delta
   
   # Ubuntu/Debian
   sudo apt install git-delta
   ```

## Other TUI Applications

### htop
htop should automatically use colors with the configured TERM variable.

### ranger
For ranger file manager, colors should work out of the box. For better integration:
```bash
# In ~/.config/ranger/rc.conf
set colorscheme default
set preview_images true
set preview_images_method kitty  # or ueberzug, w3m
```

### vim/neovim
For consistent colors in vim:
```vim
" Add to ~/.vimrc or ~/.config/nvim/init.vim
set termguicolors
colorscheme your-favorite-colorscheme
```

### tmux
For tmux color support:
```bash
# Add to ~/.tmux.conf
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
```

## Terminal Emulator Recommendations

For best TUI experience, use one of these modern terminal emulators:

- **Alacritty** - GPU-accelerated, excellent performance
- **Kitty** - Feature-rich, great image support
- **WezTerm** - Cross-platform, highly configurable
- **iTerm2** - macOS only, very polished

All of these support 24-bit truecolor by default.

## Color Scheme Consistency

To maintain consistent colors across all TUI applications, consider:

1. Use a terminal color scheme (e.g., Nord, Gruvbox, Dracula)
2. Configure your terminal emulator to use that scheme
3. Use the same color scheme in vim/neovim
4. Configure lazygit colors to match your scheme

## References

- [Truecolor terminal support](https://github.com/termstandard/colors)
- [lazygit documentation](https://github.com/jesseduffield/lazygit)
- [delta documentation](https://github.com/dandavison/delta)
