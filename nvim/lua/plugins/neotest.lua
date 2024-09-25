return {
  "nvim-neotest/neotest",
  event = "BufRead",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "lawrence-laz/neotest-zig",
  },
  opts = {},
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-count=1", "-timeout=60s", "-race" },
        }),
        require("neotest-zig"),
      },
      output_panel = {
        enable = true,
        open = "botright split | resize 5",
      },
      quickfix = {
        open = false,
      },
    })

    local map = vim.keymap.set

    map(
      "n",
      "<leader>tt",
      "<cmd>lua require('neotest').run.run()<cr>",
      { desc = "Neotest: run the test", noremap = true, silent = false }
    )
    map(
      "n",
      "<leader>tf",
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      { desc = "Neotest: run the test file", noremap = true, silent = false }
    )
    map(
      "n",
      "<leader>tp",
      "<cmd>lua require('neotest').output_panel.toggle()<cr>",
      { desc = "Neotest: toggle the test output panel", noremap = true, silent = false }
    )
    map(
      "n",
      "<leader>ts",
      "<cmd>lua require('neotest').summary.toggle()<cr>",
      { desc = "Neotest: toggle the test summary", noremap = true, silent = false }
    )
  end,
}
