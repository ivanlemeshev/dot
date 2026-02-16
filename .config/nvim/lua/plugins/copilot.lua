return {
  {
    -- Copilot integration
    -- https://github.com/zbirenbaum/copilot.lua
    "zbirenbaum/copilot.lua",
    commit = "3faffefbd6ddeb52578535ec6b730e0b72d7fd1a",
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

      map(
        "n",
        "<leader>cd",
        "<cmd>Copilot disable<CR>",
        { desc = "Copilot: disable" }
      )
      map(
        "n",
        "<leader>ce",
        "<cmd>Copilot enable<CR>",
        { desc = "Copilot: enable" }
      )
    end,
  },
}
