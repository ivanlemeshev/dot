vim.pack.add({
  {
    src = "https://github.com/nvim-telescope/telescope.nvim",
    name = "telescope.nvim",
    version = "v0.2.1",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

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

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>ff", builtin.find_files, { desc = "Telescope: find files", noremap = true, silent = true })

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
end, { desc = "Telescope: find in project files", noremap = true, silent = true })

map("n", "<leader>fd", builtin.diagnostics, { desc = "Telescope: find in diagnostics", noremap = true, silent = true })

map("n", "<leader>fb", builtin.buffers, { desc = "Telescope: find in opened buffers", noremap = true, silent = true })

map(
  "n",
  "<leader>fc",
  builtin.current_buffer_fuzzy_find,
  { desc = "Telescope: find in the current buffer", noremap = true, silent = true }
)

map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: find in help", noremap = true, silent = true })

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({
    additional_args = function(_)
      return { "--hidden", "--no-ignore" }
    end,
  })
end, { desc = "Telescope: find in all files", noremap = true, silent = true })
