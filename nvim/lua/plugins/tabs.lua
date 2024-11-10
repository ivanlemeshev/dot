return {
  "romgrk/barbar.nvim",
  lazy = false,
  version = "^1.0.0",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    auto_hide = 1, -- Hide the tab bar when there is only one tab
    animation = false,
    tabpages = true,
    clickable = true,
  },
}
