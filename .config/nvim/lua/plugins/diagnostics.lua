local helpers = require("config.helpers")
local diagnostic_colors = require("config.diagnostics")

local function apply_ansi_highlights()
  local prefix = "TinyInlineDiagnosticVirtualText"
  local inverse_prefix = "TinyInlineInvDiagnosticVirtualText"

  for name, color in pairs(diagnostic_colors) do
    for _, suffix in ipairs({ "", "CursorLine" }) do
      vim.api.nvim_set_hl(0, prefix .. name .. suffix, {
        ctermfg = color.ctermfg,
        ctermbg = 0,
      })
      vim.api.nvim_set_hl(0, inverse_prefix .. name .. suffix, {
        ctermfg = color.ctermfg,
        ctermbg = 0,
      })
    end

    vim.api.nvim_set_hl(0, prefix .. name .. "NoBg", { ctermfg = color.ctermfg })
    vim.api.nvim_set_hl(0, inverse_prefix .. name .. "NoBg", { ctermfg = color.ctermfg })

    for other_name in pairs(diagnostic_colors) do
      vim.api.nvim_set_hl(0, prefix .. name .. "Mix" .. other_name, {
        ctermfg = color.ctermfg,
        ctermbg = 0,
      })
    end
  end

  vim.api.nvim_set_hl(0, prefix .. "Bg", { ctermbg = 0 })
  vim.api.nvim_set_hl(0, prefix .. "Arrow", { ctermfg = 8, ctermbg = 0 })
  vim.api.nvim_set_hl(0, prefix .. "ArrowNoBg", { ctermfg = 8 })
end

vim.pack.add({
  {
    src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    name = "tiny-inline-diagnostic.nvim",
    version = "main",
  },
}, {
  load = false,
  confirm = false, -- Install without confirmation
})

helpers.load_on(
  "VimEnter",
  "pack-diagnostics",
  "tiny-inline-diagnostic.nvim",
  function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      options = {
        show_source = true,
        use_icons_from_diagnostic = true,
      },
    })
    apply_ansi_highlights()
  end
)
