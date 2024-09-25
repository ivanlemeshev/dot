return {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufRead",
  main = "ibl",
  opts = {
    indent = {
      char = "▏",
    },
    exclude = {
      filetypes = {
        "help",
      },
    },
  },
}
