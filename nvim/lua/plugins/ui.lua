return {
  -- Alpha Dashboard
  {
    'goolord/alpha-nvim',
    dependencies = { 'nvim-mini/mini.icons' },
    config = function ()
      local dashboard = require'alpha.themes.dashboard'
      -- This seems to be relative to the main init.lua config in the dotfiles/nvim folder
      local header_path = vim.fn.stdpath('config') .. '/rice/headers/run.txt'
      if vim.fn.filereadable(header_path) == 1 then
        dashboard.section.header.val = vim.fn.readfile(header_path)
      else
        dashboard.section.header.val = {
          '░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓██████████████▓▒░',
          '░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░',
          '░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░',
          '░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░',
          '░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░',
          '░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░',
          '░▒▓█▓▒░░▒▓█▓▒░  ░▒▓██▓▒░  ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░',
        }
      end
      
      -- Recent files util
      local function open_oldfiles()
        local files = {}
        for _, f in ipairs(vim.v.oldfiles) do
          if vim.fn.filereadable(f) == 1 then
            table.insert(files, f)
          end
        end
        if #files == 0 then
          vim.notify("No recent files", vim.log.levels.INFO)
          return
        end
        vim.ui.select(files, { prompt = "Recent files" }, function(choice)
          if choice then
            vim.cmd("edit " .. vim.fn.fnameescape(choice))
          end
        end)
      end
      _G.alpha_open_oldfiles = open_oldfiles

      -- Sessions utils
      local session_dir = vim.fn.stdpath('state') .. '/sessions'
      vim.fn.mkdir(session_dir, 'p')

      local function save_session(name)
        name = name or vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        local file = session_dir .. '/' .. name .. '.vim'
        vim.cmd('mksession! ' .. vim.fn.fnameescape(file))
        vim.notify('Session saved: ' .. file)
      end

      local function list_sessions()
        local sessions = vim.split(vim.fn.glob(session_dir .. '/*.vim'), '\n', { trimempty = true })
        if #sessions == 0 then
          vim.notify('No sessions found', vim.log.levels.INFO)
          return
        end
        vim.ui.select(sessions, { prompt = 'Sessions' }, function(choice)
          if choice then
            vim.cmd('source ' .. vim.fn.fnameescape(choice))
          end
        end)
      end
      _G.alpha_select_session = list_sessions

      vim.api.nvim_create_user_command('SessionSave', function(opts)
        save_session(opts.args ~= '' and opts.args or nil)
      end, { nargs = '?' })

      vim.api.nvim_create_user_command('SessionList', function()
        list_sessions()
      end, {})

      dashboard.section.buttons.val = {
        dashboard.button('e', '  New file', ':ene <BAR> startinsert<CR>'),
        dashboard.button('f', '  File tree', ':NvimTreeToggle<CR>'),
        dashboard.button('r', '  Recent files', ':lua alpha_open_oldfiles()<CR>'),
        dashboard.button('s', '  Sessions', ':lua alpha_select_session()<CR>'),
        dashboard.button('q', '  Quit', ':qa<CR>'),
      }
      local quote_path = vim.fn.stdpath('config') .. '/rice/quotes/dijkstra.txt'
      local footer = {}
      if vim.fn.filereadable(quote_path) == 1 then
        for _, line in ipairs(vim.fn.readfile(quote_path)) do
          table.insert(footer, line)
        end
      else
        footer = { 'You typod your quote file path. -Me' }
      end
      dashboard.section.footer.val = footer
      require'alpha'.setup(dashboard.config)
    end
  },

  -- Nvim-Tree
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
    keys = {
      { "<leader>e", ":NvimTreeToggle<CR>", noremap = true, silent = true }
    }
  },

  -- Indent Blankline
  {
    "saghen/blink.indent",
  },

  -- Markdown Renderer
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
}
