return {
  -- Gruvbox Material theme for Neovim
  -- https://github.com/sainnhe/gruvbox-material
  "sainnhe/gruvbox-material",
  priority = 1000,
  config = function()
    -- Configuration for gruvbox-material
    -- Available values: 'hard', 'medium'(default), 'soft'
    vim.g.gruvbox_material_background = "medium"
    -- Available values: 'material', 'mix', 'original'
    vim.g.gruvbox_material_foreground = "material"
    vim.g.gruvbox_material_enable_italic = true
    vim.g.gruvbox_material_enable_bold = true
    vim.g.gruvbox_material_transparent_background = 0
    vim.g.gruvbox_material_better_performance = 1

    -- Make panels use the same background as the editor
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "gruvbox-material",
      callback = function()
        local hl = vim.api.nvim_set_hl
        hl(0, "TroubleNormal", { link = "Normal" })
        hl(0, "TroubleNormalNC", { link = "Normal" })
      end,
    })

    -- Setup must be called before loading.
    vim.cmd.colorscheme("gruvbox-material")
  end,
}
