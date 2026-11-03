local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-tree.lua",
    name = "nvim-tree.lua",
    version = "v1.17.0",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

require("nvim-tree").setup({
  filesystem_watchers = { enable = false },
  view = { width = 40 },
  filters = {
    custom = { "^.git$" }, -- Hide .git directory
  },
  renderer = {
    icons = {
      glyphs = {
        modified = "",
        git = {
          unstaged = "",
          staged = "",
          unmerged = "!",
          renamed = "",
          untracked = "?",
          deleted = "",
          ignored = "",
        },
      },
    },
  },
  git = { ignore = false }, -- Show git-ignored files
  actions = {
    open_file = {
      quit_on_open = false, -- Don't close nvim-tree when opening a file
    },
  },
  diagnostics = {
    enable = true, -- Show diagnostics
  },
  update_focused_file = {
    enable = true, -- Update the focused file in the tree
  },
})

-- Auto-refresh nvim-tree when Neovim gains focus
local nvim_tree_augroup =
  vim.api.nvim_create_augroup("nvim-tree-refresh", { clear = true })
vim.api.nvim_create_autocmd("FocusGained", {
  group = nvim_tree_augroup,
  pattern = "*",
  callback = function()
    local api = require("nvim-tree.api")
    if api.tree.is_visible() then
      api.tree.reload()
    end
  end,
})
