--- *lem.terminal* Built-in terminal utilities for Neovim
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local M = {}

---@class LemTerminalConfig
---@field size? number Terminal window height in lines (default: 20)
---@field direction? "horizontal"|"vertical"|"float" Terminal direction (default: "horizontal")
---@field start_in_insert? boolean Start in insert mode (default: true)
---@field position? "top"|"bottom"|"left"|"right" Split position (default: "bottom" for horizontal, "right" for vertical)

---@type LemTerminalConfig
local defaults = {
  size = 20,
  direction = "horizontal",
  start_in_insert = true,
  position = nil, -- auto: bottom for horizontal, right for vertical
}

--- Active configuration
---@type LemTerminalConfig
M.config = vim.deepcopy(defaults)

--- Terminal state
local terminal_buf = nil
local terminal_win = nil

--- Setup the terminal module with custom configuration
---@param config? LemTerminalConfig Custom configuration options
function M.setup(config)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), config or {})
  M.setup_keymaps()
end

--- Check if terminal window is open
local function is_terminal_open()
  return terminal_win and vim.api.nvim_win_is_valid(terminal_win)
end

--- Open terminal window
function M.toggle()
  -- If terminal window is open, close it
  if is_terminal_open() then
    if terminal_win then
      vim.api.nvim_win_close(terminal_win, true)
    end
    terminal_win = nil
    return
  end

  -- Reuse existing buffer or create new one
  if not terminal_buf or not vim.api.nvim_buf_is_valid(terminal_buf) then
    terminal_buf = vim.api.nvim_create_buf(false, true)
  end

  if M.config.direction == "horizontal" then
    local position = M.config.position or "bottom"
    local cmd = position == "bottom" and "botright split" or "topleft split"
    vim.cmd(cmd)
    vim.api.nvim_win_set_buf(0, terminal_buf)
    vim.cmd("resize " .. M.config.size)
    terminal_win = vim.api.nvim_get_current_win()

    -- Start terminal if buffer is empty
    if
      vim.api.nvim_buf_line_count(terminal_buf) == 1
      and vim.api.nvim_buf_get_lines(terminal_buf, 0, 1, false)[1] == ""
    then
      vim.cmd("terminal")
    end
  elseif M.config.direction == "vertical" then
    local position = M.config.position or "right"
    local cmd = position == "right" and "botright vsplit" or "topleft vsplit"
    vim.cmd(cmd)
    vim.api.nvim_win_set_buf(0, terminal_buf)
    vim.cmd("vertical resize " .. M.config.size)
    terminal_win = vim.api.nvim_get_current_win()

    -- Start terminal if buffer is empty
    if
      vim.api.nvim_buf_line_count(terminal_buf) == 1
      and vim.api.nvim_buf_get_lines(terminal_buf, 0, 1, false)[1] == ""
    then
      vim.cmd("terminal")
    end
  elseif M.config.direction == "float" then
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    terminal_win = vim.api.nvim_open_win(terminal_buf, true, {
      relative = "editor",
      width = width,
      height = height,
      col = math.floor((vim.o.columns - width) / 2),
      row = math.floor((vim.o.lines - height) / 2),
      style = "minimal",
      border = "rounded",
    })

    -- Start terminal if buffer is empty
    if
      vim.api.nvim_buf_line_count(terminal_buf) == 1
      and vim.api.nvim_buf_get_lines(terminal_buf, 0, 1, false)[1] == ""
    then
      vim.cmd("terminal")
    end
  end

  if M.config.start_in_insert then
    vim.cmd("startinsert")
  end
end

--- Setup default keymaps
function M.setup_keymaps()
  local map = vim.keymap.set

  -- Toggle terminal
  map("n", "<leader>tr", M.toggle, {
    desc = "Terminal: toggle",
    noremap = true,
    silent = true,
  })

  -- Close terminal
  map("t", "<C-q>", function()
    if is_terminal_open() and terminal_win then
      vim.api.nvim_win_close(terminal_win, true)
      terminal_win = nil
    end
  end, { noremap = true, silent = true, desc = "Terminal: close" })

  -- Navigate from terminal to other windows
  map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal: move left" })
  map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal: move down" })
  map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal: move up" })
  map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal: move right" })

  -- Auto insert mode when entering terminal buffer
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.buftype == "terminal" then
        vim.cmd("startinsert")
      end
    end,
  })
end

return M
