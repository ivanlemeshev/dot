return {
  "lukas-reineke/indent-blankline.nvim",
  commit = "005b56001b2cb30bfa61b7986bc50657816ba4ba",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "▏",
      tab_char = "▏",
    },
    exclude = {
      filetypes = {
        "help",
      },
      buftypes = {
        "terminal",
      },
    },
    scope = {
      enabled = false,
    },
  },
}
