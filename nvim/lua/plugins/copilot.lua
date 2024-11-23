return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = false,
          },
        },
        suggestion = {
          auto_trigger = true, -- Copilot starts suggesting as soon as you enter insert mode
          keymap = {
            accept = "<C-f>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-e>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
          gitcommit = true,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })

      local map = vim.keymap.set

      map("n", "<leader>cd", "<cmd>Copilot disable<CR>", { desc = "Copilot: disable" })
      map("n", "<leader>ce", "<cmd>Copilot enable<CR>", { desc = "Copilot: enable" })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {},
    config = function()
      require("CopilotChat").setup({
        debug = true,
      })

      local map = vim.keymap.set

      map("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Copilot: toggle chat" })
      map("v", "<leader>ce", "<esc><cmd>CopilotChatExplain<cr>", { desc = "Copilot: explain the selected text" })
    end,
  },
}
