return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  -- commit = "d9c8e7b1a0c5f2e4a3b1c9e5f8a2b6c7d8e9f0a1",
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
}
