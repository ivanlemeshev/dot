local M = {}
local namespace = vim.api.nvim_create_namespace("lem.todo")
local progress_buffer

local function task_state(line)
  return line:match("^%s*%- %[([ xX])%]")
end

function M.update_progress()
  if progress_buffer and vim.api.nvim_buf_is_valid(progress_buffer) then
    vim.api.nvim_buf_clear_namespace(progress_buffer, namespace, 0, -1)
  end
  progress_buffer = nil

  if vim.api.nvim_get_mode().mode ~= "n" or vim.bo.buftype ~= "" then
    return
  end

  local buffer = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local function state_at(index)
    return task_state(vim.api.nvim_buf_get_lines(buffer, index, index + 1, false)[1] or "")
  end

  if not state_at(row) then
    return
  end

  local first, last = row, row
  while first > 0 and state_at(first - 1) do
    first = first - 1
  end
  while last + 1 < vim.api.nvim_buf_line_count(buffer) and state_at(last + 1) do
    last = last + 1
  end

  local complete = 0
  for _, line in ipairs(vim.api.nvim_buf_get_lines(buffer, first, last + 1, false)) do
    if task_state(line) ~= " " then
      complete = complete + 1
    end
  end

  local total = last - first + 1
  local label = ("  %d/%d (%d%%)"):format(complete, total, math.floor(complete / total * 100 + 0.5))
  vim.api.nvim_buf_set_extmark(buffer, namespace, row, 0, {
    virt_text = { { label, "Comment" } },
    virt_text_pos = "eol",
  })
  progress_buffer = buffer
end

function M.toggle(first, last)
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local changed = false

  for index, line in ipairs(lines) do
    local prefix, state, suffix = line:match("^(%s*%- %[)([ xX])(%].*)$")
    if prefix then
      lines[index] = prefix .. (state == " " and "x" or " ") .. suffix
      changed = true
    end
  end

  if changed then
    vim.api.nvim_buf_set_lines(0, first - 1, last, false, lines)
    M.update_progress()
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("lem-todo", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter", "TextChanged", "ModeChanged" }, {
    group = group,
    callback = M.update_progress,
  })
  vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    callback = function(args)
      vim.api.nvim_buf_clear_namespace(args.buf, namespace, 0, -1)
    end,
  })
  vim.api.nvim_create_user_command("TodoToggle", function(opts)
    M.toggle(opts.line1, opts.line2)
  end, { range = true, desc = "Toggle task checkboxes" })

  vim.keymap.set("n", "<leader>x", "<cmd>TodoToggle<CR>", { desc = "Toggle task checkbox" })
  vim.keymap.set("x", "<leader>x", ":TodoToggle<CR>", { desc = "Toggle task checkboxes" })
  M.update_progress()
end

return M
