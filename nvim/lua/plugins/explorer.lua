vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-tree.lua",
    name = "nvim-tree.lua",
    version = "v1.17.0",
  },
}, {
  load = true,
  confirm = false,
})

require("nvim-tree").setup({
  filesystem_watchers = { enable = false },
  view = { width = 40 },
  filters = {
    custom = { "^.git$" },
  },
  renderer = {
    highlight_git = "name",
    icons = {
      web_devicons = {
        file = { enable = true, color = true },
      },
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
  git = { ignore = false },
  actions = {
    open_file = {
      quit_on_open = false,
    },
  },
  diagnostics = {
    enable = true,
  },
  update_focused_file = {
    enable = true,
  },
})

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
