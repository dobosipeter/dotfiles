local M = {}

M.is_termux = (vim.fn.has("android") == 1)
  or ((vim.env.PREFIX or ""):match("com.termux") ~= nil)

-- Check for devcontainers
M.is_devcontainer = (vim.fn.glob("/.banner") ~= "")
  or (vim.env.REMOTE_CONTAINERS == "true")
  or (vim.env.DEVCONTAINER == "true")

-- Check if pip is available
M.has_pip = function()
  return vim.fn.executable('pip3') == 1 or vim.fn.executable('pip') == 1
end

return M
