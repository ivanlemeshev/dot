vim.cmd.colorscheme 'catppuccin'

require('catppuccin').setup({
    flavour = 'macchiato',
    intergrations = {
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
    },
})
