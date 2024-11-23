return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({})

    local Terminal = require("toggleterm.terminal").Terminal
    local float_term = Terminal:new({
      direction = "float",
      float_opts = {
        border = "curved",
      },
    })

    function _G.toggle_float_term()
      float_term:toggle()
    end

    vim.keymap.set({ "n", "t" }, "<leader>tr", "<CMD>lua toggle_float_term()<CR>", { noremap = true, silent = true })
  end,
}
