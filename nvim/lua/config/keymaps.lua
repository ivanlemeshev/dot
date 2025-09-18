-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

map("n", ";", ":", { desc = "Enter command mode" })

map(
  "n",
  "<leader>pv",
  vim.cmd.Ex,
  { desc = "Back to netrw from the current buffer", silent = true }
)

-- Keep the cursor centered when scrolling
map(
  "n",
  "<C-d>",
  "<C-d>zz",
  { desc = "Scroll down half a page", noremap = true, silent = true }
)
map(
  "n",
  "<C-u>",
  "<C-u>zz",
  { desc = "Scroll up half a page", noremap = true, silent = true }
)
map(
  "n",
  "<C-f>",
  "<C-f>zz",
  { desc = "Scroll down a page", noremap = true, silent = true }
)
map(
  "n",
  "<C-b>",
  "<C-b>zz",
  { desc = "Scroll up a page", noremap = true, silent = true }
)

-- Keep the cursor centered when moving
map(
  "n",
  "n",
  "nzzzv",
  { desc = "Move to the next search result", noremap = true, silent = true }
)
map(
  "n",
  "N",
  "Nzzzv",
  { desc = "Move to the previous search result", noremap = true, silent = true }
)

-- Buffers
map(
  "n",
  "<Tab>",
  ":bnext<CR>",
  { desc = "Switch to the next buffer", noremap = true, silent = true }
)
map(
  "n",
  "<S-Tab>",
  ":bprevious<CR>",
  { desc = "Switch to the previous buffer", noremap = true, silent = true }
)
map(
  "n",
  "<leader>w",
  "<cmd>w<CR>",
  { desc = "Save the current buffer", noremap = true, silent = true }
)
map(
  "n",
  "<leader>q",
  "<cmd>BufferClose<CR>",
  { desc = "Quit the current buffer", noremap = true, silent = true }
)
map(
  "n",
  "<leader>x",
  ":bdelete!<CR>",
  { desc = "Close the current buffer", noremap = true, silent = true }
)
map(
  "n",
  "<leader>b",
  "<cmd>enew<CR>",
  { desc = "New empty buffer", noremap = true, silent = true }
)

-- Panes management
map(
  "n",
  "<leader>v",
  "<C-w>v",
  { desc = "Split the pane vertically", noremap = true, silent = true }
)
map(
  "n",
  "<leader>h",
  "<C-w>s",
  { desc = "Split the pane horizontally", noremap = true, silent = true }
)
map(
  "n",
  "<leader>se",
  "<C-w>=",
  { desc = "Equalize the pane sizes", noremap = true, silent = true }
)
map(
  "n",
  "<leader>xs",
  ":close<CR>",
  { desc = "Close the currrent pane", noremap = true, silent = true }
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
  ":resize -2<CR>",
  { desc = "Resize the pane up", noremap = true, silent = true }
)
map(
  "n",
  "<Down>",
  ":resize +2<CR>",
  { desc = "Resize the pane down", noremap = true, silent = true }
)
map(
  "n",
  "<Left>",
  ":vertical resize -2<CR>",
  { desc = "Resize the pane left", noremap = true, silent = true }
)
map(
  "n",
  "<Right>",
  ":vertical resize +2<CR>",
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
