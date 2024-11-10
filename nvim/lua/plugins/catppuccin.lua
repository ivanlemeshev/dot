return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  setup = function()
    require("catppuccin").setup({
      integrations = {
        -- For more plugins integrations please scroll down
        -- https://github.com/catppuccin/nvim#integrations
        barbar = true,
        cmp = true,
        fidget = true,
        gitsigns = true,
        markdown = true,
        mason = true,
        neottest = true,
        neotree = true,
        treesitter = true,
        treesitter_context = true,
      },
    })
  end,
}
