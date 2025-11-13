# NVim dotfiles  
  
Use a recent nvim version (I'm running v0.11.4).  

Further ideas I would like to explore, configure, learn:  
* telescope
* ~auto-session~ 
    * ~track down the weird bug with documentation hover not working in auto-session loaded sessions~
* which-key.nvim 
* venv-selector 
* enable/implement simple linting fixes (potentially with copilot?) 
* find/peek/go to source of symbol in new view?
* duplicate current view into new tab
* highlight all instances of symbol under cursor
~* folding methods~
* configure pylint to use the correct/current venv

## Structure  
  
~/.config/nvim/
├── init.lua
└── lua/
    ├── core/
    │   ├── autocmds.lua  <-- q to quit hover, auto tooltip
    │   ├── keymaps.lua   <-- diagnostic float
    │   └── options.lua   <-- All vim.opt and vim.g settings, diagnostics config
    │
    ├── plugins/
    │   ├── init.lua      <-- lazy.nvim _(pluginmanager)_ bootstrap, setup
    │   ├── colorscheme.lua
    │   ├── completion.lua  <-- nvim-cmp, luasnip, autopairs
    │   ├── lsp.lua         <-- lspconfig _(basedpyright, clangd)_, mason, none/null-ls
    │   ├── tools.lua       <-- treesitter, gitsigns, copilot-chat, auto-session
    │   └── ui.lua          <-- nvim-tree _(file tree)_, alpha _(startup dashboard ui)_, blink (indent lines), render-markdown
    │
    └── utils.lua         <-- is_termux helper


## Keymaps  
  
* Leader is \  
* \-e for filetree
* \-c for Copilot Chat
* K (shift+k) is documentation hover 
* gl is diagnostic hover 
* Ctrl + l clear highlight after search
* zo open fold under cursor
* zc close fold under cursor
* zR open all folds
* zM close all folds
* za toggle fold under cursor
* zj/zk move to next/previous fold
* [z jump out of nested structure
* ]z jump out of nested Structure

### LSP shortcuts  
  
* gd goes to definition
* gr goes to references
* \-r renames symbol
* \-a Shows code action menu (lsp suggestions, e.g.: import symbol, etc)
  
#### Completions  
  
* Ctrl-k Scroll to previous item
* Ctrl-j Scroll to next item
* Ctrl-b Scroll docs up
* Ctrl-f Scroll docs down
* Ctrl-e Close completion/mapping window
* Ctrl-Return Accept completion
  
### Opening terms  
  
* :term
* :term python for a python shell
* :vsplit | term
* :split | term
* :tabnew | term
* Exit term insert mode: Ctrl-\ Ctrl-n
* :q or Ctrl-d to close the shell when it ends
