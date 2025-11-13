local M = {}

M.is_termux = (vim.fn.has("android") == 1)
  or ((vim.env.PREFIX or ""):match("com.termux") ~= nil)

return M
