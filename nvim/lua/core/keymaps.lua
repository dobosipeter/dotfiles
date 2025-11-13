local keymap = vim.keymap.set

-- Keymap for diagnostic floating window
keymap("n", "gl", function()
  vim.diagnostic.open_float(nil, {
    scope = "cursor",
    border = "rounded",
    focusable = true,
    close_events = { "InsertEnter" },
    source = "if_many",
  })
end, { noremap = true, silent = true })

