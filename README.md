# dotfiles

Personal configuration files for Neovim, Kitty, and zsh.

## Structure

```
nvim/          Neovim config (modular Lua, lazy.nvim)
kitty/         Kitty terminal config
zsh/           zsh / Oh My Zsh config
docs/          Dependency and setup documentation
```

See [docs/DEPENDENCIES.md](docs/DEPENDENCIES.md) for system prerequisites and
[nvim/README.md](nvim/README.md) for detailed Neovim notes (keymaps, plugins, workflows).

## Setup

Clone the repository:

```sh
git clone https://github.com/dobosipeter/dotfiles.git
```

Symlink whichever configs you want into their expected locations:

```sh
ln -s ~/git/dotfiles/nvim   ~/.config/nvim
ln -s ~/git/dotfiles/kitty  ~/.config/kitty
```
