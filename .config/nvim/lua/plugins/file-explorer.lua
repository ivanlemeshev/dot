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

    -- Match NvimTree background with the editor (deferred to run after
    -- gruvbox-material's lazy highlight loading)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NvimTree",
      callback = function()
        vim.schedule(function()
          local hl = vim.api.nvim_set_hl
          hl(0, "NvimTreeNormal", { link = "Normal" })
          hl(0, "NvimTreeNormalNC", { link = "Normal" })
          hl(0, "NvimTreeEndOfBuffer", { link = "Normal" })
          hl(0, "NvimTreeWinSeparator", { fg = "#45403d", bg = "#282828" })
        end)
      end,
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
