-- Disable netrw
-- Replaced by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Personal settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"

-- Download and setup Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load Lazy plugin manager
require("lazy").setup({
  spec = {
    { "rebelot/kanagawa.nvim" },
    {
      "neovim/nvim-lspconfig",
      dependencies = { "williamboman/nvim-lsp-installer" },
    },
    {
      "nvimtools/none-ls.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
      "L3MON4D3/LuaSnip",
      dependencies = { "rafamadriz/friendly-snippets" },
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "L3MON4D3/LuaSnip",
      },
    },
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup {}
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
	    view = {
		    width = 30,
	    },
	    renderer = {
		    group_empty = true,
	    },
	    filters = {
		    dotfiles = true,
	    },
        })
      end,
    },
  },
  checker = { enabled = true },
})

-- Setup Null LS
local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.pylint,
  },
})

-- Setup CMP
local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local autopairs = require("nvim-autopairs")

local function format_item(item)
  if item.label and item.kind and item.kind == "Function" then
    return item.label .. "(${1:args})"
  end
  return item.abbr or item.label or ""
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "path" },
    { name = "buffer" },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.abbr = format_item(vim_item)
      if vim_item.abbr == "" then
        vim_item.abbr = vim_item.word
      end
      return vim_item
    end,
  },
})

-- Setup LuaSnip
luasnip.config.setup({
  history = true,
  update_events = "TextChanged,TextChangedI",
})

-- Setup Autopairs
autopairs.setup({
  disable_filetype = { "TelescopePrompt" },
  disable_in_macro = false,
  disable_in_visualblock = false,
  ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
  enable_moveright = true,
  enable_afterquote = true,
  enable_check_bracket_line = true,
  enable_bracket_in_quote = true,
  enable_abbr = false,
  break_undo = true,
  check_ts = false,
  map_bs = true,
  map_c_h = false,
  map_c_w = false,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
})

-- Setup event handlers
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- Load LuaSnip snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Setup Pyright LSP
require("lspconfig").pyright.setup {
  cmd = { "pyright-langserver", "--stdio" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

-- Setup Clangd LSP for C++
require("lspconfig").clangd.setup {
  cmd = { "clangd", "--background-index" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  filetypes = { "c", "cpp" },
}

-- Set colorscheme
vim.cmd("colorscheme kanagawa-dragon")

-- Set nvim-tree keymap
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
