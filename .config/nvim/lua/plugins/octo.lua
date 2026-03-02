return {
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
}
