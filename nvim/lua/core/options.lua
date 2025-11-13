local opt = vim.opt
local g = vim.g
local utils = require('utils')

-- Disable netrw
-- Replaced by nvim-tree
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Personal settings
opt.number = true
opt.relativenumber = true
opt.signcolumn = "number"
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Folding
opt.foldmethod = "indent"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "0"

-- Termux specific clipboard
if utils.is_termux then
  g.clipboard = {
    name = "termux-clipboard",
    copy = {["+"] = "termux-clipboard-set", ["*"] = "termux-clipboard-set"},
    paste = {["+"] = "termux-clipboard-get", ["*"] = "termux-clipboard-get"},
    cache_enabled = 0,
  }
end

-- Use ripgrep for :grep / :vimgrep if available
if vim.fn.executable("rg") == 1 then
  opt.grepprg = "rg --vimgrep --smart-case --hidden --follow --no-heading --color=never --glob '!.git/'"
  opt.grepformat = "%f:%l:%c:%m"
end

-- Better diagnostics UX
vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
    focusable = true,
    header = "Diagnostics",
    prefix = function(diag, i, total)
      local name = vim.diagnostic.severity[diag.severity]
      return string.format("%s: ", name)
    end,
  },
})
