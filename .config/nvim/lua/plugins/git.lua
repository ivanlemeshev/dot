return {
  {
    -- Git integration for buffers
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    commit = "31217271a7314c343606acb4072a94a039a19fb5",
    event = { "BufReadPre", "BufNewFile" },
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
        desc = "Git: close view",
      },
      {
        "<leader>gpr",
        function()
          local branch =
            vim.fn.systemlist({ "git", "symbolic-ref", "--short", "HEAD" })[1]
          if not branch or branch == "" then
            vim.notify(
              "Could not determine current branch",
              vim.log.levels.WARN
            )
            return
          end
          local merge_ref = vim.fn.systemlist({
            "git",
            "config",
            "--get",
            ("branch.%s.merge"):format(branch),
          })[1]
          local remote = vim.fn.systemlist({
            "git",
            "config",
            "--get",
            ("branch.%s.remote"):format(branch),
          })[1] or "origin"
          local target = merge_ref and merge_ref:match("^refs/heads/(.+)$")
          if (not target or target == branch) and remote and remote ~= "" then
            local remote_head = vim.fn.systemlist({
              "git",
              "symbolic-ref",
              ("refs/remotes/%s/HEAD"):format(remote),
            })[1]
            if remote_head then
              local remote_branch =
                remote_head:match("^refs/remotes/[^/]+/(.+)$")
              target = remote_branch or target
            end
          end
          if not target then
            vim.notify(
              ("Could not determine PR target branch for %s (branch.%s.merge missing)"):format(
                branch,
                branch
              ),
              vim.log.levels.WARN
            )
            return
          end
          local base = remote .. "/" .. target
          vim.cmd("DiffviewOpen " .. base .. "...HEAD")
        end,
        desc = "Git: PR diff vs upstream",
      },
      {
        "<leader>gPC",
        "<cmd>DiffviewClose<CR>",
        desc = "Git: close PR diff view",
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
        desc = "Git: list GitHub issues",
      },
      {
        "<leader>gp",
        "<CMD>Octo pr list<CR>",
        desc = "Git: list GitHub pull requests",
      },
      {
        "<leader>gd",
        "<CMD>Octo discussion list<CR>",
        desc = "Git: list GitHub discussions",
      },
      {
        "<leader>gn",
        "<CMD>Octo notification list<CR>",
        desc = "Git: list GitHub notifications",
      },
      {
        "<leader>gs",
        function()
          require("octo.utils").create_base_search_command({
            include_current_repo = true,
          })
        end,
        desc = "Git: search GitHub issues and pull requests",
      },
    },
  },
}
