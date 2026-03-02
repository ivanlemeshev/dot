return {
  {
    -- Git integration for Vim
    -- https://github.com/tpope/vim-fugitive
    "tpope/vim-fugitive",
    commit = "61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4",
  },
  {
    -- Git integration for buffers
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    commit = "31217271a7314c343606acb4072a94a039a19fb5",
    opts = {},
    config = function(_, opts)
      require("gitsigns").setup(opts)

      local map = vim.keymap.set

      map(
        "n",
        "<leader>gb",
        "<cmd>Gitsigns blame_line<CR>",
        { desc = "Git: blame line" }
      )
    end,
  },
  {
    "sindrets/diffview.nvim",
    -- https://github.com/sindrets/diffview.nvim
    -- Keep the plugin lazy-loaded until a diff command is used.
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
      "DiffviewClose",
      "DiffviewToggleFiles",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enhanced_diff_hl = true,
      use_icons = true,
    },
    keys = {
      {
        "<leader>gv",
        "<cmd>DiffviewOpen<CR>",
        desc = "Git: open Diffview",
      },
      {
        "<leader>gV",
        "<cmd>DiffviewFileHistory<CR>",
        desc = "Git: view file history",
      },
      {
        "<leader>gC",
        "<cmd>DiffviewClose<CR>",
        desc = "Git: close Diffview",
      },
      {
        "<leader>gpr",
        function()
          local base = vim.fn.systemlist(
            "git rev-parse --abbrev-ref --symbolic-full-name @{u}"
          )[1]
          if not base or base == "" then
            vim.notify("Could not resolve upstream branch", vim.log.levels.WARN)
            return
          end
          vim.cmd("DiffviewOpen " .. base .. "...HEAD")
        end,
        desc = "Git: PR diff vs upstream",
      },
    },
  },
}
