return {
  -- LSP Config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "nvimtools/none-ls.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local utils = require('utils')

      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, noremap = true, silent = true }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      end

      local caps = require("cmp_nvim_lsp").default_capabilities()

      -- Setup basedpyright
      vim.lsp.config('basedpyright', {
        capabilities = caps,
        on_attach = on_attach,
      })
      vim.lsp.enable('basedpyright')

      -- Setup lua_ls
      vim.lsp.config('lua_ls', {
        capabilities = caps,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      vim.lsp.enable('lua_ls')

      -- Setup texlab, but not in devcontainers
      if not utils.is_devcontainer then
        vim.lsp.config('texlab', {
          capabilities = caps,
          on_attach = on_attach,
        })
        vim.lsp.enable('texlab')
      end
      -- Setup clangd
      local clangd_caps = vim.tbl_deep_extend("force", {}, caps, { offsetEncoding = { "utf-16" } })
      if not utils.is_termux and vim.fn.executable('clangd') then
        vim.lsp.config('clangd', {
          capabilities = clangd_caps,
          on_attach = on_attach,
        })
        vim.lsp.enable('clangd')
      end
    end,
  },

  -- Mason: install, updtate lsp servers, linters, formatters
  {
    "williamboman/mason.nvim",
    config = function()
      local utils = require('utils')
      require("mason").setup({
        PATH = utils.is_termux and "append" or "prepend",
      })
    end,
  },

  -- Mason-LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local utils = require('utils')

      -- Define base tools
      local tools = { "basedpyright", "lua_ls" }

      -- Add environment-specific tools
      if not utils.is_termux then
        table.insert(tools, "clangd")
      end
      if not utils.is_devcontainer then
        table.insert(tools, "texlab")
      end

      require("mason-lspconfig").setup({
        ensure_installed = tools,
        automatic_installation = utils.is_termux and { exclude = { "clangd" } } or true,
      })
    end,
  },

  -- Mason-Tool-Installer
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      local utils = require('utils')

      -- Define base tools
      local mti_tools = { "basedpyright", "pylint", "lua_ls" }

      -- Add environment-specific tools
      if not utils.is_termux then
        table.insert(mti_tools, "clangd")
      end
      if not utils.is_devcontainer then
        table.insert(mti_tools, "texlab")
      end

      require("mason-tool-installer").setup({
        ensure_installed = mti_tools,
        auto_update = true,
        run_on_start = true,
        start_delay = 300,
      })
    end,
  },

  -- Null-LS (now none-ls)
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.pylint,
        },
      })
    end,
  },
}
