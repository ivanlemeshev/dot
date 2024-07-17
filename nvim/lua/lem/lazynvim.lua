local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { "nvim-lua/plenary.nvim" },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
        },
        {
            "nvim-telescope/telescope.nvim",
            event = "VimEnter",
            branch = "0.1.x",
            dependencies = {
                "nvim-treesitter/nvim-treesitter",
                "nvim-lua/plenary.nvim",
            },
        },
        {
            "catppuccin/nvim",
            event = "VimEnter",
            priority = 1000,
        },
        { "nvim-treesitter/playground" },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
        },
        { "mbbill/undotree" },
        { "tpope/vim-fugitive" },
        -- LSP Zero
        { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/nvim-cmp' },
        { 'L3MON4D3/LuaSnip' },
    },
    checker = {
        -- automatically check for plugin updates
        enabled = true,
    },
})
