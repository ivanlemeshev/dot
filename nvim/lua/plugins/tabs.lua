return {
  "romgrk/barbar.nvim",
  version = "^1.0.0",
  dependencies = {
    "lewis6991/gitsigns.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  init = function()
    vim.g.barbar_auto_setup = false
  end,
  opts = {
    auto_hide = 1,
    tabpages = true,
    clickable = true,
    sidebar_filetypes = {
      ["neo-tree"] = { event = "BufWipeout" },
    },
  },
}
