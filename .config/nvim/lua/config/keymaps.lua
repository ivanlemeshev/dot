-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- Simplify command mode entry
map("n", ";", ":", { desc = "Enter command mode" })

-- Keep the cursor centered when scrolling
map(
  "n",
  "<C-d>",
  "<C-d>zz", -- Scroll down half a page and center the cursor
  { desc = "Scroll down half a page", noremap = true, silent = true }
)
map(
  "n",
  "<C-u>",
  "<C-u>zz", -- Scroll up half a page and center the cursor
  { desc = "Scroll up half a page", noremap = true, silent = true }
)
map(
  "n",
  "<C-f>",
  "<C-f>zz", -- Scroll down a full page and center the cursor
  { desc = "Scroll down a page", noremap = true, silent = true }
)
map(
  "n",
  "<C-b>",
  "<C-b>zz", -- Scroll up a full page and center the cursor
  { desc = "Scroll up a page", noremap = true, silent = true }
)

-- Keep the cursor centered when moving
map(
  "n",
  "n",
  "nzzzv", -- Move to the next search result and center the cursor
  { desc = "Move to the next search result", noremap = true, silent = true }
)
map(
  "n",
  "N",
  "Nzzzv", -- Move to the previous search result and center the cursor
  { desc = "Move to the previous search result", noremap = true, silent = true }
)

-- Buffers
map(
  "n",
  "<leader>w",
  "<cmd>w<CR>",
  { desc = "Save the current buffer", noremap = true, silent = true }
)

-- Navigate between panes
map(
  "n",
  "<C-k>",
  ":wincmd k<CR>",
  { desc = "Move to the pane above", noremap = true, silent = true }
)
map(
  "n",
  "<C-j>",
  ":wincmd j<CR>",
  { desc = "Move to the pane below", noremap = true, silent = true }
)
map(
  "n",
  "<C-h>",
  ":wincmd h<CR>",
  { desc = "Move to the pane on the left", noremap = true, silent = true }
)
map(
  "n",
  "<C-l>",
  ":wincmd l<CR>",
  { desc = "Move to the pane on the right", noremap = true, silent = true }
)

-- Resize panes
map(
  "n",
  "<Up>",
  ":resize -1<CR>",
  { desc = "Resize the pane up", noremap = true, silent = true }
)
map(
  "n",
  "<Down>",
  ":resize +1<CR>",
  { desc = "Resize the pane down", noremap = true, silent = true }
)
map(
  "n",
  "<Left>",
  ":vertical resize -1<CR>",
  { desc = "Resize the pane left", noremap = true, silent = true }
)
map(
  "n",
  "<Right>",
  ":vertical resize +1<CR>",
  { desc = "Resize the pane right", noremap = true, silent = true }
)

-- Stay in visual mode after shifting
map(
  "v",
  "<",
  "<gv",
  { desc = "Indent to the left", noremap = true, silent = true }
)
map(
  "v",
  ">",
  ">gv",
  { desc = "Indent to the right", noremap = true, silent = true }
)

-- Comments (using native Neovim 0.10+ commenting)
map("n", "<leader>/", "gcc", { desc = "Toggle line comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- NvimTree
map(
  "n",
  "<leader>e",
  ":NvimTreeToggle<CR>",
  { desc = "Toggle NvimTree", noremap = true, silent = true }
)
map(
  "n",
  "\\",
  ":NvimTreeFocus<CR>",
  { desc = "Focus NvimTree", noremap = true, silent = true }
)

-- vim.pack
map(
  "n",
  "<leader>Pu",
  ":lua vim.pack.update()<CR>",
  { desc = "Plugins: update", noremap = true, silent = true }
)
