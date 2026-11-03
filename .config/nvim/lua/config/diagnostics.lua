--- *config.diagnostics* Built-in diagnostic UI configuration
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local diagnostic_colors = {
  Error = { ctermfg = 9 },
  Warn = { ctermfg = 11 },
  Info = { ctermfg = 12 },
  Hint = { ctermfg = 14 },
  Ok = { ctermfg = 10 },
}

for name, color in pairs(diagnostic_colors) do
  for _, group in ipairs({ "", "VirtualText", "Floating", "Sign" }) do
    vim.api.nvim_set_hl(0, "Diagnostic" .. group .. name, color)
  end

  vim.api.nvim_set_hl(0, "DiagnosticUnderline" .. name, {
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
