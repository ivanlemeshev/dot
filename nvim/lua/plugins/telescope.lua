return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- See :help telescope.defaults.vimgrep_arguments
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--fixed-strings", -- allow searching without escaping special characters
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { "node_modules", ".git", ".venv", "vendor" },
          hidden = true,
        },
      },
      live_grep = {
        file_ignore_patterns = { "node_modules", ".git", ".venv", "vendor" },
        additional_args = function(_)
          return { "--hidden" }
        end,
      },
    })

    local builtin = require("telescope.builtin")
    local map = vim.keymap.set

    map("n", "<leader>ff", builtin.find_files, { desc = "Telescode: find files" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "Telescode: find in all files" })
    map("n", "<leader>fd", builtin.diagnostics, { desc = "Telescode: find in diagnostics" })
    map("n", "<leader>fb", builtin.buffers, { desc = "Telescode: find in opened buffers" })
    map("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Telescode: find in the current buffer" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "Telescode: find in help" })
  end,
}
