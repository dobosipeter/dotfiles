return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    { "<leader>f", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
  },
  opts = {
    formatters_by_ft = {
      python = { "black" },
      markdown = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  },
}
