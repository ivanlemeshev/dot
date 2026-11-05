-- Run with: nvim --clean -l tests/nvim/inline_diagnostics.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.config/nvim")
vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "/site")
vim.cmd("packadd tiny-inline-diagnostic.nvim")
local add = vim.pack.add
rawset(vim.pack, "add", function() end)
require("lem.theme").setup()
dofile(".config/nvim/lua/config/diagnostics.lua")
require("plugins.diagnostics")
vim.api.nvim_exec_autocmds("VimEnter", {})
rawset(vim.pack, "add", add)
local plugin = require("tiny-inline-diagnostic")
assert(plugin.config.signs.left == "" and plugin.config.signs.right == "")
local buffer = vim.api.nvim_get_current_buf()
vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { "local x = 1" })
vim.api.nvim_win_set_cursor(0, { 1, 6 })
vim.api.nvim_exec_autocmds(
  "LspAttach",
  { buffer = buffer, data = { client_id = 0 } }
)
local namespace = vim.api.nvim_create_namespace("inline-test-input")
vim.diagnostic.set(namespace, buffer, {
  {
    lnum = 0,
    col = 6,
    end_col = 7,
    severity = vim.diagnostic.severity.WARN,
    message = "Automatic diagnostic",
    source = "ANSI test",
  },
})
local rendered = ""
assert(
  vim.wait(1000, function()
    local parts = {}
    for _, mark in
      ipairs(
        vim.api.nvim_buf_get_extmarks(
          buffer,
          vim.api.nvim_get_namespaces().TinyInlineDiagnostic,
          0,
          -1,
          { details = true }
        )
      )
    do
      for _, chunk in ipairs(mark[4].virt_text or {}) do
        parts[#parts + 1] = chunk[1]
      end
      for _, line in ipairs(mark[4].virt_lines or {}) do
        for _, chunk in ipairs(line) do
          parts[#parts + 1] = chunk[1]
        end
      end
    end
    rendered = table.concat(parts)
    return rendered:find("Automatic diagnostic", 1, true) ~= nil
  end, 10),
  "Automatic diagnostic does not render"
)
for _, character in ipairs({ "┌", "┐", "└", "┘", "─", "│" }) do
  assert(
    rendered:find(character, 1, true),
    "The full border omits " .. character
  )
end
local virtual_text = require("tiny-inline-diagnostic.virtual_text")
local function check_frame()
  local lines, _, under = virtual_text.from_diagnostics(
    plugin.config,
    vim.diagnostic.get(buffer),
    { 0, 0 },
    buffer
  )
  local first = under and 2 or 1
  local rows = {}
  for index = first, #lines do
    local text = ""
    for _, chunk in ipairs(lines[index]) do
      text = text .. chunk[1]
    end
    rows[#rows + 1] = text
  end
  assert(rows[1]:match("^┌.*┐$"), "The top border is incomplete")
  assert(rows[#rows]:match("^└.*┘$"), "The bottom border is incomplete")
  for index, row in ipairs(rows) do
    assert(
      vim.fn.strdisplaywidth(row) == vim.fn.strdisplaywidth(rows[1]),
      "The frame sides do not align"
    )
    if index > 1 and index < #rows then
      assert(row:match("^│.*│$"), "A message row has no full side borders")
    end
  end
  return rows
end
local rows = check_frame()
print("Automatic diagnostic frame:\n" .. table.concat(rows, "\n"))
require("lem.diagnostic_border").setup()
check_frame()
vim.diagnostic.set(namespace, buffer, {
  {
    lnum = 0,
    col = 6,
    severity = vim.diagnostic.severity.WARN,
    message = "First diagnostic with multiple lines\nUnicode: 日本語",
    source = "ANSI test",
  },
  {
    lnum = 0,
    col = 6,
    severity = vim.diagnostic.severity.ERROR,
    message = "Second diagnostic",
    source = "ANSI test",
  },
})
check_frame()

vim.api.nvim_buf_set_lines(buffer, 0, -1, false, { string.rep("x", 100) })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
check_frame()
local border = vim.api.nvim_get_hl(
  0,
  { name = "TinyInlineInvDiagnosticVirtualTextWarn", link = false }
)
assert(
  border.ctermfg == 8 and border.ctermbg == 0,
  "Border uses invisible colors"
)
vim.api.nvim_exec_autocmds("ColorScheme", {})
border = vim.api.nvim_get_hl(
  0,
  { name = "TinyInlineInvDiagnosticVirtualTextWarn", link = false }
)
assert(
  border.ctermfg == 8 and border.ctermbg == 0,
  "ColorScheme replaces ANSI border colors"
)
