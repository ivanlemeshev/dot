local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    name = "gitsigns.nvim",
    version = "v2.1.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

helpers.load_on(
  { "BufReadPre", "BufNewFile" },
  "pack-gitsigns",
  "gitsigns.nvim",
  function()
    require("gitsigns").setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 1000,
      },
    })

    helpers.nmap(
      "<leader>gb",
      "<cmd>Gitsigns blame_line<CR>",
      "Git: blame line"
    )
  end
)
