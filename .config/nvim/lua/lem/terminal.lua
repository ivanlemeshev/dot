--- *lem.terminal* Built-in terminal utilities for Neovim
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local M = {}

---@class LemTerminalConfig
---@field width_percent? number Terminal window width as percentage (default: 0.8)
---@field height_percent? number Terminal window height as percentage (default: 0.8)
---@field start_in_insert? boolean Start in insert mode (default: true)

---@type LemTerminalConfig
local defaults = {
  width_percent = 0.8,
  height_percent = 0.8,
  start_in_insert = true,
}

--- Active configuration
---@type LemTerminalConfig
M.config = vim.deepcopy(defaults)

--- Terminal state
local terminal_buf = nil
local terminal_win = nil
local backdrop_win = nil

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
    if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
      vim.api.nvim_win_close(backdrop_win, true)
    end
    backdrop_win = nil
    return
  end

  -- Reuse existing buffer or create new one
  if not terminal_buf or not vim.api.nvim_buf_is_valid(terminal_buf) then
    -- Create unlisted scratch buffer
    terminal_buf = vim.api.nvim_create_buf(false, true)
  end

  -- Open floating terminal window
  local width = math.floor(vim.o.columns * M.config.width_percent)
  local height = math.floor(vim.o.lines * M.config.height_percent)

  -- Backdrop behind the terminal window
  backdrop_win = vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), false, {
    relative = "editor",
    width = vim.o.columns,
    height = vim.o.lines,
    row = 0,
    col = 0,
    style = "minimal",
    focusable = false,
    zindex = 49,
  })
  vim.wo[backdrop_win].winhighlight = "Normal:TerminalBackdrop"
  vim.wo[backdrop_win].winblend = 60

  terminal_win = vim.api.nvim_open_win(terminal_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "single",
  })

  vim.wo[terminal_win].winhighlight = "NormalFloat:Normal"

  -- Start terminal if buffer is empty
  if
    vim.api.nvim_buf_line_count(terminal_buf) == 1
    and vim.api.nvim_buf_get_lines(terminal_buf, 0, 1, false)[1] == ""
  then
    vim.cmd("terminal")
    -- Ensure buffer stays unlisted after terminal is created
    vim.bo[terminal_buf].buflisted = false
    vim.bo[terminal_buf].bufhidden = "hide"
  end

  if M.config.start_in_insert then
    vim.cmd("startinsert")
  end
end

--- Setup default keymaps
function M.setup_keymaps()
  local map = vim.keymap.set

  -- Toggle terminal
  map("n", "<C-\\>", M.toggle, {
    desc = "Terminal: toggle",
    noremap = true,
    silent = true,
  })

  -- Exit and close terminal
  map("t", "<C-\\>", function()
    if is_terminal_open() and terminal_win then
      vim.api.nvim_win_close(terminal_win, true)
      terminal_win = nil
      if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
        vim.api.nvim_win_close(backdrop_win, true)
      end
      backdrop_win = nil
    end
  end, { noremap = true, silent = true, desc = "Terminal: close" })

  -- Auto insert mode when entering terminal buffer
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      if vim.bo.buftype == "terminal" then
        vim.cmd("startinsert")
      end
    end,
  })

  -- Close terminal when clicking outside
  vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
      if is_terminal_open() and terminal_win then
        local current_win = vim.api.nvim_get_current_win()
        if current_win == terminal_win then
          vim.schedule(function()
            if is_terminal_open() and terminal_win then
              vim.api.nvim_win_close(terminal_win, true)
              terminal_win = nil
              if backdrop_win and vim.api.nvim_win_is_valid(backdrop_win) then
                vim.api.nvim_win_close(backdrop_win, true)
              end
              backdrop_win = nil
            end
          end)
        end
      end
    end,
  })

  -- Disable all scrolling in terminal to prevent losing focus
  map("t", "<ScrollWheelUp>", "<Nop>", { noremap = true, silent = true })
  map("t", "<ScrollWheelDown>", "<Nop>", { noremap = true, silent = true })
end

return M
