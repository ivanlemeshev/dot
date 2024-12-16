local terminal_win_id = nil
local terminal_buf_id = nil

local function toggle_terminal()
  if terminal_window_id and vim.api.nvim_win_is_valid(terminal_window_id) then
    vim.api.nvim_win_close(terminal_window_id, true)
    terminal_window_id = nil
    return
  end

  local editor_height = vim.api.nvim_get_option("lines")

  local height = math.floor(editor_height / 2)

  vim.cmd.vnew()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, height)

  terminal_window_id = vim.api.nvim_get_current_win()

  if terminal_buffer_id and vim.api.nvim_buf_is_valid(terminal_buffer_id) then
    vim.api.nvim_win_set_buf(terminal_window_id, terminal_buffer_id)
  else
    vim.cmd.term()
    terminal_buffer_id = vim.api.nvim_get_current_buf()
  end

  vim.api.nvim_feedkeys("i", "n", true)
end

_G.toggle_terminal = toggle_terminal

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.keymap.set(
  { "n" },
  "<leader>tr",
  "<CMD>lua toggle_terminal()<CR>",
  { desc = "Terminal: toggle", noremap = true, silent = true }
)

vim.keymap.set({ "t" }, "<Esc>", "<C-\\><C-n>", { desc = "Terminal: go to normal mode", noremap = true, silent = true })
