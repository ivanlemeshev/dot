local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    name = "tiny-inline-diagnostic.nvim",
    version = "main",
  },
}, {
  load = false, -- Load after colorscheme
  confirm = false, -- Install without confirmation
})

helpers.load_on(
  "VimEnter",
  "pack-diagnostics",
  "tiny-inline-diagnostic.nvim",
  function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      transparent_bg = true,
      options = {
        show_source = true,
        use_icons_from_diagnostic = true,
      },
    })

    local apply_colors = require("lem.theme").setup_inline_diagnostics
    apply_colors()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = helpers.augroup("inline-diagnostic-colors"),
      callback = apply_colors,
    })
  end
)
