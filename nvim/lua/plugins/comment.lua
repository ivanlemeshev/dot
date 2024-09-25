return {
  "numToStr/Comment.nvim",
  event = "BufRead",
  opts = {},
  config = function()
    local map = vim.keymap.set

    map(
      "n",
      "<leader>/",
      require("Comment.api").toggle.linewise.current,
      { desc = "Toggle line commet", noremap = true, silent = true }
    )
    map(
      "v",
      "<leader>/",
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      { desc = "Toggle comment on the selected text", noremap = true, silent = true }
    )
  end,
}
