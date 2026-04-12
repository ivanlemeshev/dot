local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
    name = "tiny-inline-diagnostic.nvim",
    version = "main",
  },
}, {
  load = false, -- Load after colorscheme
  confirm = false, -- Install without confirmation
})

helpers.load_on(
  "VimEnter",
  "pack-diagnostics",
  "tiny-inline-diagnostic.nvim",
  function()
    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      options = {
        show_source = true,
        use_icons_from_diagnostic = true,
      },
    })
  end
)

helpers.nmap("<leader>dd", function()
  require("plugins.search").fzf().diagnostics_workspace()
end, "Diagnostics: workspace")

helpers.nmap("<leader>dc", function()
  require("plugins.search").fzf().diagnostics_document()
end, "Diagnostics: current buffer")
