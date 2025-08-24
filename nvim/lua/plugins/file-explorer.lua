return {
  -- File explorer tree
  -- https://github.com/nvim-tree/nvim-tree.lua
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      view = { width = 40 },
      filters = {
        custom = { "^.git$" },
      },
      renderer = {
        icons = {
          glyphs = {
            modified = "",
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "",
              untracked = "★",
              deleted = "",
              ignored = "",
            },
          },
        },
      },
      git = { ignore = false },
    })

    local map = vim.keymap.set

    map(
      "n",
      "<leader>ft",
      "<cmd>NvimTreeFindFile<CR>",
      { desc = "Files: find the file in the file explorer" }
    )
  end,
}
