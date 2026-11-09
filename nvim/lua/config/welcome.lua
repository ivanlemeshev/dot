local M = {}

function M.close()
  if vim.bo.filetype == "welcome" then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_set_current_buf(buf)
  end
end

function M.show()
  if vim.bo.filetype == "welcome" or vim.bo.modified then
    return
  end
  local startup_buf = vim.api.nvim_get_current_buf()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "welcome"
  vim.bo[buf].modifiable = false
  vim.api.nvim_set_current_buf(buf)
  if vim.api.nvim_buf_is_valid(startup_buf) then
    vim.api.nvim_buf_delete(startup_buf, {})
  end

  local win = vim.api.nvim_get_current_win()
  local group = vim.api.nvim_create_augroup("welcome-layout", { clear = true })
  local namespace = vim.api.nvim_create_namespace("welcome")
  local window_options = {
    number = false,
    relativenumber = false,
    signcolumn = "no",
    foldcolumn = "0",
    cursorline = false,
    cursorcolumn = false,
    colorcolumn = "",
    list = false,
    wrap = false,
    statuscolumn = "",
    fillchars = "eob: ",
  }
  local saved_window = {}
  for name, value in pairs(window_options) do
    saved_window[name] = vim.api.nvim_get_option_value(name, { win = win })
    vim.api.nvim_set_option_value(name, value, { win = win })
  end
  local saved_windows = { [win] = saved_window }
  local saved_global = {}
  local global_options = {
    laststatus = 0,
    showmode = false,
    ruler = false,
    showcmd = false,
  }
  for name, value in pairs(global_options) do
    saved_global[name] = vim.api.nvim_get_option_value(name, { scope = "global" })
    vim.api.nvim_set_option_value(name, value, { scope = "global" })
  end

  local leader = vim.g.mapleader or "\\"
  local label = leader == " " and "Space" or vim.fn.keytrans(leader)
  local entries = {
    { label .. " fn", "New file", leader .. "fn" },
    { label .. " ff", "Find file", leader .. "ff" },
    { label .. " fg", "Find text", leader .. "fg" },
    { label .. " fo", "Recent files", leader .. "fo" },
    { label .. " e", "File explorer", leader .. "e" },
    { ":q", "Quit", ":q<CR>" },
  }
  local selected = 1
  local first_row = 1

  local function render()
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
      return
    end
    vim.api.nvim_set_hl(0, "WelcomeTitle", { ctermfg = 4, bold = true })
    vim.api.nvim_set_hl(0, "WelcomeShortcut", { ctermfg = 8 })
    vim.api.nvim_set_hl(0, "WelcomeSelected", { ctermfg = 0, ctermbg = 4 })
    local key_width = 0
    local text_width = 0
    for _, entry in ipairs(entries) do
      key_width = math.max(key_width, vim.fn.strdisplaywidth(entry[1]))
      text_width = math.max(text_width, vim.fn.strdisplaywidth(entry[2]))
    end
    local width = key_width + 2 + text_width
    local left = math.max(
      0,
      math.floor((vim.api.nvim_win_get_width(win) - width) / 2)
    )
    local top = math.max(
      0,
      math.floor((vim.api.nvim_win_get_height(win) - #entries - 2) / 2)
    )
    local lines = {}
    for _ = 1, top do
      lines[#lines + 1] = ""
    end
    lines[#lines + 1] = string.rep(
      " ",
      left + math.floor((width - 6) / 2)
    ) .. "Neovim"
    lines[#lines + 1] = ""
    for _, entry in ipairs(entries) do
      local gap = key_width - vim.fn.strdisplaywidth(entry[1]) + 2
      lines[#lines + 1] = string.rep(" ", left)
        .. entry[1]
        .. string.rep(" ", gap)
        .. entry[2]
        .. string.rep(" ", text_width - vim.fn.strdisplaywidth(entry[2]))
    end
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.api.nvim_buf_clear_namespace(buf, namespace, 0, -1)
    vim.api.nvim_buf_set_extmark(buf, namespace, top, 0, {
      end_col = #lines[top + 1],
      hl_group = "WelcomeTitle",
    })
    for index, entry in ipairs(entries) do
      if index ~= selected then
        vim.api.nvim_buf_set_extmark(buf, namespace, top + 1 + index, left, {
          end_col = left + #entry[1],
          hl_group = "WelcomeShortcut",
        })
      end
    end
    first_row = top + 3
    local row = first_row + selected - 1
    vim.api.nvim_buf_set_extmark(buf, namespace, row - 1, left, {
      end_col = #lines[row],
      hl_group = "WelcomeSelected",
      hl_mode = "replace",
      priority = 200,
    })
    vim.api.nvim_win_set_cursor(win, { row, left })
  end

  for _, key in ipairs({ "j", "<Down>", "k", "<Up>" }) do
    vim.keymap.set("n", key, function()
      local step = (key == "j" or key == "<Down>") and 1 or -1
      selected = (selected - 1 + step) % #entries + 1
      render()
    end, { buffer = buf, silent = true, desc = "Select welcome action" })
  end
  vim.keymap.set("n", "<CR>", function()
    local keys = vim.api.nvim_replace_termcodes(
      entries[selected][3],
      true,
      false,
      true
    )
    vim.api.nvim_feedkeys(keys, "m", false)
  end, { buffer = buf, silent = true, desc = "Run welcome action" })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = buf,
    callback = function()
      local row = vim.api.nvim_win_get_cursor(win)[1]
      local index = math.max(1, math.min(#entries, row - first_row + 1))
      if index ~= selected or row ~= first_row + index - 1 then
        selected = index
        render()
      end
    end,
  })

  vim.api.nvim_create_autocmd({ "VimResized", "WinResized", "ColorScheme" }, {
    group = group,
    callback = render,
  })
  vim.api.nvim_create_autocmd("WinNew", {
    group = group,
    callback = function()
      if vim.api.nvim_get_current_buf() == buf then
        -- NOTE: A split inherits the welcome window options.
        saved_windows[vim.api.nvim_get_current_win()] = vim.deepcopy(saved_window)
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function()
      local current_win = vim.api.nvim_get_current_win()
      if vim.api.nvim_get_current_buf() ~= buf then
        saved_windows[current_win] = {}
        for name in pairs(window_options) do
          saved_windows[current_win][name] =
            vim.api.nvim_get_option_value(name, { win = current_win })
        end
        return
      end
      if saved_windows[current_win] then
        for name, value in pairs(saved_windows[current_win]) do
          vim.api.nvim_set_option_value(name, value, { win = current_win })
        end
        saved_windows[current_win] = nil
      end
      for name, value in pairs(saved_global) do
        vim.api.nvim_set_option_value(name, value, { scope = "global" })
      end
    end,
  })
  vim.api.nvim_create_autocmd("BufWinEnter", {
    group = group,
    buffer = buf,
    callback = function()
      local current_win = vim.api.nvim_get_current_win()
      if not saved_windows[current_win] then
        saved_windows[current_win] = {}
        for name in pairs(window_options) do
          saved_windows[current_win][name] =
            vim.api.nvim_get_option_value(name, { win = current_win })
        end
      end
      for name, value in pairs(window_options) do
        vim.api.nvim_set_option_value(name, value, { win = current_win })
      end
      for name, value in pairs(global_options) do
        vim.api.nvim_set_option_value(name, value, { scope = "global" })
      end
      render()
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    buffer = buf,
    once = true,
    callback = function()
      vim.api.nvim_del_augroup_by_id(group)
    end,
  })
  render()
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("welcome", { clear = true }),
  once = true,
  callback = function()
    local argument = vim.fn.argv(0)
    local directory = vim.fn.argc() == 1
      and type(argument) == "string"
      and vim.fn.isdirectory(argument) == 1
    if vim.fn.argc() > 0 and not directory then
      return
    end
    if vim.bo.modified or (not directory and vim.api.nvim_buf_get_name(0) ~= "") then
      return
    end

    if directory and type(argument) == "string" then
      vim.cmd.cd(vim.fn.fnamemodify(argument, ":p"))
    end

    M.show()
  end,
})

return M
