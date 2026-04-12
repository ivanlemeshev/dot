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

local diagnostics_group =
  vim.api.nvim_create_augroup("pack-diagnostics", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = diagnostics_group,
  once = true,
  callback = function()
    vim.cmd.packadd("tiny-inline-diagnostic.nvim")

    require("tiny-inline-diagnostic").setup({
      preset = "modern",
      options = {
        show_source = true,
        use_icons_from_diagnostic = true,
      },
    })
  end,
})

-- Keymaps - using fzf-lua for diagnostics
local map = vim.keymap.set

map("n", "<leader>dd", function()
  require("plugins.search").fzf().diagnostics_workspace()
end, { desc = "Diagnostics: workspace", noremap = true, silent = true })

map("n", "<leader>dc", function()
  require("plugins.search").fzf().diagnostics_document()
end, { desc = "Diagnostics: current buffer", noremap = true, silent = true })
