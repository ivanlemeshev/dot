-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    view = {
        width = 40,
    },
    renderer = {
        highlight_git = "all",
        highlight_diagnostics = "all",
        icons = {
            git_placement = "after",
        },
        special_files = {},
    },
    filters = {
        enable = true,
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = { '.git' },
        exclude = {},
    },
})
