return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "\\",
      ":Neotree reveal<CR>",
      desc = "Go to NeoTree",
      noremap = true,
      silent = true,
    },
    {
      "<leader>e",
      ":Neotree toggle position=left<CR>",
      desc = "Toggle NeoTree",
      noremap = true,
      silent = true,
    },
  },
  init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly
    -- requiring it, because `cwd` is not set up properly.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require "neo-tree"
          end
        end
      end,
    })
  end,
  opts = {
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          ".git",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
    },
  },
}
