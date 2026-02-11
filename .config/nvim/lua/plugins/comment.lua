return {
  -- Smart and powerful comment plugin
  -- https://github.com/numToStr/Comment.nvim
  "numToStr/Comment.nvim",
  commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
  config = function()
    local map = vim.keymap.set
    map(
      "n",
      "<leader>/",
      require("Comment.api").toggle.linewise.current,
      { desc = "Toggle line comment", noremap = true, silent = true }
    )
    map(
      "v",
      "<leader>/",
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
      {
        desc = "Toggle comment on the selected text",
        noremap = true,
        silent = true,
      }
    )
  end,
}
