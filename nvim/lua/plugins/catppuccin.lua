return {
  "catppuccin/nvim",
  priority = 1000,
  setup = function()
    require("catppuccin").setup({
      integrations = {
        -- For more plugins integrations please scroll down
        -- https://github.com/catppuccin/nvim#integrations
        cmp = true,
        gitsigns = true,
        neotree = true,
        treesitter = true,
      },
    })
  end,
}
