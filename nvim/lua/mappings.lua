require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>ct", vim.cmd.CopilotChat, { desc = "Open the Copilot chat" })
map("n", "<leader>ce", vim.cmd.CopilotChatExplain, { desc = "Ask Copilot to explain the selected code" })
