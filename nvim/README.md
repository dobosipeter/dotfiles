# Neovim dotfiles

Use a recent nvim version (I'm running v0.11.4).

Further ideas I would like to explore or configure:
* which-key.nvim
* venv-selector
* enable/implement simple linting fixes (potentially with copilot?)
* find/peek/go to source of symbol in new view?
* duplicate current view into new tab
* configure pylint to use the correct/current venv

## Structure

```
~/.config/nvim/
├── init.lua
├── KEYBINDINGS.md          <-- all keybindings organized by tool
└── lua/
    ├── core/
    │   ├── autocmds.lua    <-- LSP highlight, navic, q-to-quit floats, spell for prose
    │   ├── keymaps.lua     <-- diagnostic float (gl)
    │   └── options.lua     <-- vim.opt/vim.g, diagnostics config, Termux clipboard
    │
    ├── plugins/
    │   ├── init.lua        <-- lazy.nvim bootstrap and spec list
    │   ├── colorscheme.lua <-- kanagawa-dragon
    │   ├── completion.lua  <-- nvim-cmp, LuaSnip, autopairs
    │   ├── formatting.lua  <-- conform.nvim (black, prettier) format-on-save
    │   ├── harpoon.lua     <-- harpoon2 file navigation
    │   ├── lsp.lua         <-- lspconfig, mason, mason-tool-installer, none-ls (pylint)
    │   ├── telescope.lua   <-- telescope fuzzy finder
    │   ├── tools.lua       <-- treesitter, gitsigns, spellwarn, vimtex, CopilotChat
    │   └── ui.lua          <-- alpha, nvim-tree, lualine, navic, satellite, blink.indent, render-markdown
    │
    └── utils.lua           <-- is_termux, is_devcontainer, has_pip()
```


## Keybindings

See [KEYBINDINGS.md](KEYBINDINGS.md) for all keybindings organized by tool.
