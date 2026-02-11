return {
  -- File explorer tree
  -- https://github.com/nvim-tree/nvim-tree.lua
  "nvim-tree/nvim-tree.lua",
  commit = "037d89e60fb01a6c11a48a19540253b8c72a3c32",
  dependencies = {
    { "kyazdani42/nvim-web-devicons", commit = "746ffbb17975ebd6c40142362eee1b0249969c5c" },
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

    -- Auto-refresh nvim-tree when gaining focus or buffer changes
    local nvim_tree_augroup =
      vim.api.nvim_create_augroup("nvim-tree-refresh", { clear = true })
    vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
      group = nvim_tree_augroup,
      pattern = "*",
      callback = function()
        local api = require("nvim-tree.api")
        if api.tree.is_visible() then
          api.tree.reload()
        end
      end,
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
