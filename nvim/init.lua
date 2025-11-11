-- Disable netrw
-- Replaced by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Personal settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "number"
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Termux specific configurations
local is_termux = (vim.fn.has("android") == 1)
  or ((vim.env.PREFIX or ""):match("com.termux") ~= nil)

if is_termux then
  vim.g.clipboard = {
    name = "termux-clipboard",
    copy = {["+"] = "termux-clipboard-set", ["*"] = "termux-clipboard-set"},
    paste = {["+"] = "termux-clipboard-get", ["*"] = "termux-clipboard-get"},
    cache_enabled = 0,
  }
end

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
    { "rebelot/kanagawa.nvim" },
    { "neovim/nvim-lspconfig", },
    { "WhoIsSethDaniel/mason-tool-installer.nvim" },
    { "williamboman/mason.nvim" }, 
    {
	"williamboman/mason-lspconfig.nvim",
	dependencies = { "neovim/nvim-lspconfig" } },
    {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate" },
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
	    		view = { width = 30, },
	    		renderer = { group_empty = true, },
	    		filters = { dotfiles = true, },
        	})
      	end,
    },
    {"lewis6991/gitsigns.nvim"},
    {
      "rmagatti/auto-session",
      opts = {
        log_level = "error",
        suppressed_dirs = { "~/", "~/Downloads", "/" },
        git_use_branch_name = true,
        bypass_save_file_types = { "alpha", "dashboard" },
      },
    },
    {
	    "CopilotC-Nvim/CopilotChat.nvim",
	    dependencies = { 
		    { "nvim-lua/plenary.nvim", branch = "master" },
		    -- { "MeanderingProgrammer/render-markdown.nvim" },
	    },
	    build = "make tiktoken",
	    opts = {
		    model = "claude-sonnet-4.5",
		    temperature = 0.45,
		    window = {
			    layout = "vertical",
			    width = 0.4,
			    border = "rounded",
			    title = "Copilot Chat",
			    position = 'right',
		    },
		    headers = {
			    user = '- User',
			    assistant = '- Model',
			    tool = 'Tool',
		    },
		    separator = '-',
		    auto_fold = false,
		    auto_insert_mode = false,
	    },
    },
    {
	    "MeanderingProgrammer/render-markdown.nvim",
	    opts = {
		    file_types = { "markdown", "copilot-chat" },
		    sign = { enabled = false },
		    heading = {
			    sign = false,
		    },
	    },
	    ft = { "markdown", "copilot-chat" },
    },

  },
  checker = { enabled = true },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "vim", "vimdoc", "python", "cpp" },
  highlight = { enable = true },
})

require("gitsigns").setup({
	signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
	numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = true, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
})

-- Mason: installs/updates LSP servers, linters, formatters
require("mason").setup({
	-- On Termux, append Mason’s bin so system binaries are preferred.
	PATH = is_termux and "append" or "prepend",
})

local mti_tools = { "basedpyright", "pylint" }
if not is_termux then table.insert(mti_tools, "clangd") end

require("mason-tool-installer").setup({
  ensure_installed = mti_tools,
  auto_update = true,
  run_on_start = true,
  start_delay = 300,
})

-- Mason-LSPConfig: bridge between Mason and Neovim’s LSP
require("mason-lspconfig").setup({
  ensure_installed = is_termux
    and { "basedpyright" }
    or  { "basedpyright", "clangd" },
  automatic_installation = is_termux and { exclude = { "clangd" } } or true,
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

local caps = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config('basedpyright', {
  capabilities = caps,
})
vim.lsp.enable('basedpyright')

-- clangd needs utf-16 offsetEncoding
local clangd_caps = vim.tbl_deep_extend("force", {}, caps, { offsetEncoding = { "utf-16" } })
if vim.fn.executable('clangd') then
  vim.lsp.config('clangd', { capabilities = clangd_caps })
  vim.lsp.enable('clangd')
end

-- Set colorscheme
vim.cmd("colorscheme kanagawa-dragon")

-- Set nvim-tree keymap
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Set CopilotChat keymap
vim.api.nvim_set_keymap("n", "<leader>c", ":CopilotChatToggle<CR>", { noremap = true, silent = true })

-- Use ripgrep for :grep / :vimgrep if available
if vim.fn.executable("rg") == 1 then
  -- search recursively, smart-case, include dotfiles, follow symlinks
  vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --follow --no-heading --color=never --glob '!.git/'"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Better diagnostics UX: floating window
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

-- Keymaps
-- K (shift+k) is documentation hover
-- gl is diagnostic hover
--Ctrl + l clear highlight after search
--zo open fold under cursor
--zc close fold under cursor
--zR open all folds
--zM close all folds
--za toggle fold under cursor
--zj/zk move to next/previous fold
--[z jump out of nested structure
--]z jump out of nested structure


vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float(nil, {
    scope = "cursor",
    border = "rounded",
    focusable = true,
    close_events = { "InsertEnter" },
    source = "if_many",
  })
end, { noremap = true, silent = true })

-- Map q to quit the hover float, when focused
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg and cfg.relative ~= "" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
    end
  end,
})

-- Auto-show a small tooltip when paused on an error 
vim.o.updatetime = 600
vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		vim.diagnostic.open_float(nil, {
			scope = "cursor",
			border = "rounded",
			focusable = true,
			source = "if_many",
			close_events = { "CursorMoved", "InsertEnter"},
		})
	end,
})

-- Basic LSP shourtcuts
-- gd goes to definition
-- gr goes to references
-- Leader r renames symbol
-- Leader r shows code action menu (lsp suggestions, e.g.: import symbol, etc.)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
    -- Explicit docs hover (fixes behavior in auto-session sessions)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  end,
})
