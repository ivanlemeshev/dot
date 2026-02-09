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

    -- Setup must be called before loading.
    vim.cmd.colorscheme("gruvbox-material")
  end,

  -- Catppuccin theme for Neovim
  -- https://github.com/catppuccin/nvim
  -- "catppuccin/nvim",
  -- priority = 1000,
  -- config = function()
  --   require("catppuccin").setup({
  --     flavour = "mocha", -- latte, frappe, macchiato, mocha
  --     integrations = {
  --       -- For more plugins integrations please scroll down
  --       -- https://github.com/catppuccin/nvim#integrations
  --       cmp = true,
  --       fidget = true,
  --       gitsigns = true,
  --       markdown = true,
  --       mason = true,
  --       neotest = true,
  --       notify = true,
  --       nvimtree = true,
  --       render_markdown = true,
  --       treesitter = true,
  --       treesitter_context = true,
  --       lsp_trouble = true,
  --       which_key = true,
  --     },
  --   })
  --
  --   -- Setup must be called before loading.
  --   vim.cmd.colorscheme("catppuccin")
  -- end,
}
