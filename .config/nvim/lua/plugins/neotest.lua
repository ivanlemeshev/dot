return {
  "nvim-neotest/neotest",
  -- Neotest is broken with the latest release,
  -- so pin to the working commit
  commit = "52fca6717ef972113ddd6ca223e30ad0abb2800c",
  lazy = false,
  dependencies = {
    { "nvim-neotest/nvim-nio", commit = "21f5324bfac14e22ba26553caf69ec76ae8a7662" },
    { "nvim-lua/plenary.nvim", commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" },
    { "antoinemadec/FixCursorHold.nvim", commit = "1900f89dc17c603eec29960f57c00bd9ae696495" },
    { "nvim-treesitter/nvim-treesitter", commit = "42fc28ba918343ebfd5565147a42a26580579482" },
    { "nvim-neotest/neotest-go", commit = "59b50505053f9c45a9febb79e11a56206c3e3901" },
    { "lawrence-laz/neotest-zig", commit = "de63f3b9a182d374d2e71cf44385326682ec90e7" },
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
      { desc = "Neotest: run the test", noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>tf",
      "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
      { desc = "Neotest: run the test file", noremap = true, silent = true }
    )
    map(
      "n",
      "<leader>tp",
      "<cmd>lua require('neotest').output_panel.toggle()<cr>",
      {
        desc = "Neotest: toggle the test output panel",
        noremap = true,
        silent = false,
      }
    )
    map("n", "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", {
      desc = "Neotest: toggle the test summary",
      noremap = true,
      silent = false,
    })
  end,
}
