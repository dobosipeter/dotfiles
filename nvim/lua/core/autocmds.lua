-- Map q to quit the hover float, when focused
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    local cfg = vim.api.nvim_win_get_config(0)
    if cfg and cfg.relative ~= "" then
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true })
    end
  end,
})

-- Auto-show a small tooltip when paused on an error (uncomment to reenable)
-- vim.o.updatetime = 600
-- vim.api.nvim_create_autocmd("CursorHold", {
--   callback = function()
--     vim.diagnostic.open_float(nil, {
--       scope = "cursor",
--       border = "rounded",
--       focusable = true,
--       source = "if_many",
--       close_events = { "CursorMoved", "InsertEnter" },
--     })
--   end,
-- })
