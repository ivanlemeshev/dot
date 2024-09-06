require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<leader>ct", vim.cmd.CopilotChat, { desc = "Open the Copilot chat" })
map("n", "<leader>ce", vim.cmd.CopilotChatExplain, { desc = "Ask Copilot to explain the selected code" })
map("i", "<C-f>", 'copilot#Accept("\\<CR>")', {
  desc = "Complete the current line using Copilot",
  expr = true,
  replace_keycodes = false,
})
vim.g.copilot_no_esc_map = true
