--- *config.diagnostics* Built-in diagnostic UI configuration
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
  underline = true,
  float = {
    border = "single",
    source = true,
    scope = "line",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})
