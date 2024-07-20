require('catppuccin').setup({
    intergrations = {
        gitsigns = true,
        markdown = true,
        nvimtree = true,
        treesitter = true,
    },
})

vim.cmd.colorscheme 'catppuccin-macchiato'
