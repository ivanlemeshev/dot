return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 20,
        persist_mode = false,
        start_in_insert = true,
        direction = "float",
        float_opts = {
          border = "rounded",
        },
      })

      local map = vim.keymap.set

      map(
        "n",
        "<leader>tr",
        "<cmd>ToggleTerm<CR>",
        { desc = "Termina: toggle", noremap = true, silent = true }
      )

      map("t", "<Esc>", "<C-\\><C-n><cmd>ToggleTerm<CR>", {
        noremap = true,
        silent = true,
        desc = "Terminal: close",
      })
    end,
  },
}
