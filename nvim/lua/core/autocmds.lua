-- Highlight all occurrences of the symbol under the cursor (LSP document highlight)
vim.o.updatetime = 200
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight") then
      local group = vim.api.nvim_create_augroup("lsp_document_highlight_" .. args.buf, { clear = true })
      vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = args.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
    if client and client:supports_method("textDocument/documentSymbol") then
      local ok, navic = pcall(require, "nvim-navic")
      if ok then navic.attach(client, args.buf) end
    end
  end,
})

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
