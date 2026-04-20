return {
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})
      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc", "python", "cpp", "markdown", "markdown_inline", "bash",
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function() pcall(vim.treesitter.start) end,
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
      local gs = require("gitsigns")
      gs.setup({
        signcolumn = false,
        numhl = true,
        linehl = true,
        word_diff = false,
        current_line_blame = true,
        on_attach = function(bufnr)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("n", "<leader>gp", gs.preview_hunk, "Gitsigns: preview hunk")
          map("n", "<leader>gd", gs.diffthis, "Gitsigns: diff against index")
          map("n", "<leader>gD", function() gs.diffthis("~") end, "Gitsigns: diff against last commit")
          map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Gitsigns: blame line")
          map("n", "<leader>gs", gs.stage_hunk, "Gitsigns: stage hunk")
          map("n", "<leader>gr", gs.reset_hunk, "Gitsigns: reset hunk")

          map("n", "]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(gs.next_hunk)
            return "<Ignore>"
          end, "Gitsigns: next hunk")
          map("n", "[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(gs.prev_hunk)
            return "<Ignore>"
          end, "Gitsigns: previous hunk")
        end,
      })
    end,
  },

  -- Diffview (rich in-editor git diff / history viewer)
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewRefresh" },
    keys = {
      { "<leader>gv", ":DiffviewOpen<CR>",          noremap = true, silent = true, desc = "Diffview: open" },
      { "<leader>gV", ":DiffviewClose<CR>",         noremap = true, silent = true, desc = "Diffview: close" },
      { "<leader>gh", ":DiffviewFileHistory<CR>",   noremap = true, silent = true, desc = "Diffview: branch file history" },
      { "<leader>gH", ":DiffviewFileHistory %<CR>", noremap = true, silent = true, desc = "Diffview: current file history" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        merge_tool = { layout = "diff3_mixed" },
      },
    },
  },

  -- Spellwarn (renders spell errors as diagnostics)
  {
    "ravibrock/spellwarn.nvim",
    event = "VeryLazy",
    config = function()
      require("spellwarn").setup()
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
