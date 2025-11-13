-- Download and setup Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load Lazy plugin manager
require("lazy").setup({
  spec = {
    require("plugins.colorscheme"),
    require("plugins.ui"),
    require("plugins.lsp"),
    require("plugins.completion"),
    require("plugins.tools"),
  },
  checker = { enabled = true },
})
