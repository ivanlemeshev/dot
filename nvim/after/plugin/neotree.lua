require("nvim-tree").setup {
  filters = {
    enable = true,
    git_ignored = false,
    dotfiles = false,
    git_clean = false,
    no_buffer = false,
    no_bookmark = false,
    custom = {
      ".git",
    },
    exclude = {},
  },
}
