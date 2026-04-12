vim.pack.add({
  {
    src = "https://github.com/zbirenbaum/copilot.lua",
    name = "copilot.lua",
    version = "v2.0.2",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local copilot_group = vim.api.nvim_create_augroup("pack-copilot", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = copilot_group,
  once = true,
  callback = function()
    vim.cmd.packadd("copilot.lua")

    require("copilot").setup({
      panel = {
        keymap = {
          open = false, -- Disable the default keymap for opening the Copilot panel
        },
      },
      suggestion = {
        auto_trigger = true, -- Copilot starts suggesting as soon as you enter insert mode
        keymap = {
          accept = "<C-f>",
          accept_word = false,
          accept_line = false,
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

    -- Keymaps
    local map = vim.keymap.set

    map("n", "<leader>cd", "<cmd>Copilot disable<CR>", { desc = "Copilot: disable", noremap = true, silent = true })
    map("n", "<leader>ce", "<cmd>Copilot enable<CR>", { desc = "Copilot: enable", noremap = true, silent = true })
  end,
})
