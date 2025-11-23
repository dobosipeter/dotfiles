return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "python", "cpp", "markdown", "markdown_inline" },
        highlight = { enable = true },
      })
    end,
  },

  -- VimTeX
  {
    "lervag/vimtex",
    lazy = false,
    -- Disable in devcontainers
    enabled = function()
      local utils = require('utils')
      return not utils.is_devcontainer
    end,
    init = function()
	vim.g.vimtex_view_method = 'zathura'
    end
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signcolumn = false,
        numhl = true,
        linehl = true,
        word_diff = false,
        current_line_blame = true,
      })
    end,
  },

  -- CopilotChat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
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
    keys = {
      { "<leader>c", ":CopilotChatToggle<CR>", noremap = true, silent = true }
    }
  },
}
