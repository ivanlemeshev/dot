return {
  -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
  -- https://github.com/nvim-telescope/telescope.nvim
  "nvim-telescope/telescope.nvim",
  commit = "ad7d9580338354ccc136e5b8f0aa4f880434dcdc",
  lazy = false,
  event = "VimEnter",
  dependencies = {
    { "nvim-lua/plenary.nvim", commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        layout_strategy = "vertical",
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
      { desc = "Telescope: find files" }
    )
    map("n", "<leader>fp", function()
      require("telescope.builtin").live_grep({
        file_ignore_patterns = {
          "node_modules",
          "%.git/",
          "%.git$",
          ".venv",
          "vendor",
        },
        additional_args = function(_)
          return { "--hidden" }
        end,
      })
    end, { desc = "Telescope: find in project files" })
    map(
      "n",
      "<leader>fd",
      builtin.diagnostics,
      { desc = "Telescope: find in diagnostics" }
    )
    map(
      "n",
      "<leader>fb",
      builtin.buffers,
      { desc = "Telescope: find in opened buffers" }
    )
    map(
      "n",
      "<leader>fc",
      builtin.current_buffer_fuzzy_find,
      { desc = "Telescope: find in the current buffer" }
    )
    map(
      "n",
      "<leader>fh",
      builtin.help_tags,
      { desc = "Telescope: find in help" }
    )
    map("n", "<leader>fg", function()
      require("telescope.builtin").live_grep({
        additional_args = function(_)
          return { "--hidden", "--no-ignore" }
        end,
      })
    end, { desc = "Telescope: find in all files" })
  end,
}
