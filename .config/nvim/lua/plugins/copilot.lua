local helpers = require("config.helpers")

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

helpers.load_on(
  { "BufReadPost", "BufNewFile" },
  "pack-copilot",
  "copilot.lua",
  function()
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

    helpers.nmap("<leader>cd", "<cmd>Copilot disable<CR>", "Copilot: disable")
    helpers.nmap("<leader>ce", "<cmd>Copilot enable<CR>", "Copilot: enable")
  end
)
