-- Catppuccin theme disabled in favor of Gruvbox
-- To re-enable: remove "enabled = false" line below

return {
  -- Catppuccin theme for Neovim
  -- https://github.com/catppuccin/nvim
  "catppuccin/nvim",
  enabled = false, -- Set to true to use Catppuccin instead of Gruvbox
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      integrations = {
        -- For more plugins integrations please scroll down
        -- https://github.com/catppuccin/nvim#integrations
        cmp = true,
        fidget = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        neotest = true,
        notify = true,
        nvimtree = true,
        render_markdown = true,
        treesitter = true,
        treesitter_context = true,
        lsp_trouble = true,
        which_key = true,
      },
    })

    -- Setup must be called before loading.
    vim.cmd.colorscheme("catppuccin")
  end,
}
