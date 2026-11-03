--- *config.diagnostics* Built-in diagnostic UI configuration
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local diagnostic_colors = {
  Error = { fg = "red", ctermfg = 9 },
  Warn = { fg = "yellow", ctermfg = 11 },
  Info = { fg = "blue", ctermfg = 12 },
  Hint = { fg = "cyan", ctermfg = 14 },
  Ok = { fg = "green", ctermfg = 10 },
}

for name, color in pairs(diagnostic_colors) do
  for _, group in ipairs({ "", "VirtualText", "Floating", "Sign" }) do
    vim.api.nvim_set_hl(0, "Diagnostic" .. group .. name, color)
  end

  vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. name, {
    fg = color.fg,
    ctermfg = color.ctermfg,
    undercurl = true,
    cterm = { underline = true },
  })
end

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
    },
  },
})

return diagnostic_colors
