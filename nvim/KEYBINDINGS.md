# Keybindings

Leader key is `\` (backslash, Neovim default).

## Diagnostics

| Key  | Action                  | Source          |
|------|-------------------------|-----------------|
| `gl` | Diagnostic float        | core/keymaps    |

## LSP

| Key         | Action          | Source     |
|-------------|-----------------|------------|
| `gd`        | Go to definition| plugins/lsp|
| `gr`        | Go to references| plugins/lsp|
| `K`         | Hover docs      | plugins/lsp|
| `<leader>r` | Rename symbol   | plugins/lsp|
| `<leader>a` | Code action     | plugins/lsp|

## Telescope

| Key          | Action           | Source            |
|--------------|------------------|-------------------|
| `<leader>ff` | Find files       | plugins/telescope |
| `<leader>fg` | Live grep        | plugins/telescope |
| `<leader>fb` | Buffers          | plugins/telescope |
| `<leader>fh` | Help tags        | plugins/telescope |
| `<leader>fd` | Diagnostics      | plugins/telescope |
| `<leader>fs` | Document symbols | plugins/telescope |
| `<leader>fr` | Recent files     | plugins/telescope |

## Harpoon

| Key          | Action           | Source          |
|--------------|------------------|-----------------|
| `<leader>ha` | Add file         | plugins/harpoon |
| `<leader>hh` | Toggle menu      | plugins/harpoon |
| `<leader>1`  | Jump to file 1   | plugins/harpoon |
| `<leader>2`  | Jump to file 2   | plugins/harpoon |
| `<leader>3`  | Jump to file 3   | plugins/harpoon |
| `<leader>4`  | Jump to file 4   | plugins/harpoon |
| `<leader>hp` | Previous file    | plugins/harpoon |
| `<leader>hn` | Next file        | plugins/harpoon |

## File tree

| Key         | Action         | Source     |
|-------------|----------------|------------|
| `<leader>e` | Toggle tree    | plugins/ui |

## Formatting

| Key         | Action         | Source             |
|-------------|----------------|--------------------|
| `<leader>f` | Format buffer  | plugins/formatting |

Format on save is also enabled (black for Python, prettier for Markdown).

## Copilot Chat

| Key         | Action         | Source         |
|-------------|----------------|----------------|
| `<leader>c` | Toggle chat    | plugins/tools  |

## Completion (nvim-cmp)

| Key      | Action              | Source              |
|----------|---------------------|---------------------|
| `Ctrl-k` | Previous item       | plugins/completion  |
| `Ctrl-j` | Next item           | plugins/completion  |
| `Ctrl-b` | Scroll docs up      | plugins/completion  |
| `Ctrl-f` | Scroll docs down    | plugins/completion  |
| `Ctrl-e` | Close menu          | plugins/completion  |
| `CR`     | Accept completion   | plugins/completion  |

## Folding (built-in)

| Key  | Action                      |
|------|-----------------------------|
| `zo` | Open fold under cursor      |
| `zc` | Close fold under cursor     |
| `za` | Toggle fold under cursor    |
| `zR` | Open all folds              |
| `zM` | Close all folds             |
| `zj` | Next fold                   |
| `zk` | Previous fold               |
| `[z` | Jump to start of fold       |
| `]z` | Jump to end of fold         |

## Session management (built-in commands)

| Command        | Action       |
|----------------|--------------|
| `:SessionSave` | Save session |
| `:SessionList` | List sessions|

## Terminal

| Command             | Action                    |
|---------------------|---------------------------|
| `:term`             | Open terminal             |
| `:term python`      | Open Python shell         |
| `:vsplit \| term`   | Terminal in vertical split|
| `:split \| term`    | Terminal in horizontal split|
| `:tabnew \| term`   | Terminal in new tab       |
| `Ctrl-\ Ctrl-n`    | Exit terminal insert mode |

## LaTeX (VimTeX)

| Key         | Action                        |
|-------------|-------------------------------|
| `<leader>ll`| Start/stop continuous compile |
| `<leader>lv`| Forward search in PDF         |
| `<leader>lc`| Clean auxiliary files         |
