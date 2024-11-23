return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      integrations = {
        -- For more plugins integrations please scroll down
        -- https://github.com/catppuccin/nvim#integrations
        cmp = true,
        fidget = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        neotest = true,
        noice = true,
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
    vim.cmd.colorscheme("catppuccin-mocha")
  end,
}
