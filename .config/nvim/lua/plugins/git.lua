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
    commit = "4516612fe98ff56ae0415a259ff6361a89419b0a",
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
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    commit = "5ae580df72589f25b775ff2bdacfd7f7be8d63bd",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      picker = "telescope",
      enable_builtin = true,
    },
    keys = {
      {
        "<leader>gl",
        "<CMD>Octo issue list<CR>",
        desc = "Octo: list GitHub issues",
      },
      {
        "<leader>gp",
        "<CMD>Octo pr list<CR>",
        desc = "Octo: list GitHub pull requests",
      },
      {
        "<leader>gd",
        "<CMD>Octo discussion list<CR>",
        desc = "Octo: list GitHub discussions",
      },
      {
        "<leader>gn",
        "<CMD>Octo notification list<CR>",
        desc = "Octo: list GitHub notifications",
      },
      {
        "<leader>gs",
        function()
          require("octo.utils").create_base_search_command({
            include_current_repo = true,
          })
        end,
        desc = "Octo: search GitHub issues and pull requests",
      },
    },
  },
}
