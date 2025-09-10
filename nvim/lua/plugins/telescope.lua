return {
  -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
  -- https://github.com/nvim-telescope/telescope.nvim
  "nvim-telescope/telescope.nvim",
  lazy = false,
  event = "VimEnter",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        layout_strategy = "vertical",
        layout_config = { width = 0.9, height = 0.9 },
        -- See :help telescope.defaults.vimgrep_arguments
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--fixed-strings", -- Allow searching without escaping special characters
        },
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-u>"] = false,
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { "node_modules", ".git", ".venv", "vendor" },
          hidden = true, -- Show hidden files
        },
        buffers = {
          mappings = {
            i = {
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
            },
          },
        },
      },
    })

    local builtin = require("telescope.builtin")
    local map = vim.keymap.set

    map(
      "n",
      "<leader>ff",
      builtin.find_files,
      { desc = "Telescode: find files" }
    )
    map("n", "<leader>fp", function()
      require("telescope.builtin").live_grep({
        file_ignore_patterns = { "node_modules", ".git", ".venv", "vendor" },
        additional_args = function(_)
          return { "--hidden" }
        end,
      })
    end, { desc = "Telescode: find in project files" })
    map(
      "n",
      "<leader>fd",
      builtin.diagnostics,
      { desc = "Telescode: find in diagnostics" }
    )
    map(
      "n",
      "<leader>b",
      builtin.buffers,
      { desc = "Telescode: find in opened buffers" }
    )
    map(
      "n",
      "<leader>fc",
      builtin.current_buffer_fuzzy_find,
      { desc = "Telescode: find in the current buffer" }
    )
    map(
      "n",
      "<leader>fh",
      builtin.help_tags,
      { desc = "Telescode: find in help" }
    )
    map("n", "<leader>fg", function()
      require("telescope.builtin").live_grep({
        additional_args = function(_)
          return { "--hidden", "--no-ignore" }
        end,
      })
    end, { desc = "Telescode: find in all file" })
  end,
}
