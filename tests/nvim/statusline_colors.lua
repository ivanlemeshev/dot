-- Run with: nvim --clean -l tests/nvim/statusline_colors.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.config/nvim")
vim.opt.packpath:prepend(vim.fn.stdpath("data") .. "/site")
vim.cmd("packadd lualine.nvim")
local add = vim.pack.add
rawset(vim.pack, "add", function() end)
require("lem.theme").setup()
dofile(".config/nvim/lua/plugins/statusline.lua")
rawset(vim.pack, "add", add)

local config = require("lualine").get_config()
local diagnostics = config.sections.lualine_y[1]
assert(diagnostics.colored and diagnostics.always_visible)
local component = require("lualine.components.diagnostics")(
  vim.tbl_extend("force", diagnostics, {
    self = { section = "y" },
    component_name = "status_test",
  })
)
local function check_render(active)
  local index = 0
  for group in component:update_status():gmatch("%%#(.-)#") do
    index = index + 1
    local name = diagnostics.sections[index]
    local expected = name == active and require("lem.theme").diagnostic[name]
      or 8
    local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
    assert(
      highlight.ctermfg == expected and highlight.ctermbg == 0,
      name .. " renders with the wrong color"
    )
  end
  assert(index == 4, "A diagnostic counter disappears")
end
local namespace = vim.api.nvim_create_namespace("statusline-color-test")
for name, severity in pairs({ error = 1, warn = 2, info = 3, hint = 4 }) do
  vim.diagnostic.reset(namespace, 0)
  assert(
    diagnostics.diagnostics_color[name]().fg == 8,
    name .. " zero count is not gray"
  )
  vim.diagnostic.set(namespace, 0, {
    { lnum = 0, col = 0, severity = severity, message = "Test diagnostic" },
  })
  local color = diagnostics.diagnostics_color[name]()
  assert(color.fg == require("lem.theme").diagnostic[name] and color.bg == 0)
  check_render(name)
end
vim.diagnostic.reset(namespace, 0)

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local function git(...)
  local args = { "git", "-C", root, ... }
  local result = vim.system(args, { text = true }):wait()
  assert(result.code == 0, result.stderr)
  return vim.trim(result.stdout)
end
local result = vim
  .system({ "git", "init", "--initial-branch=main", root }, { text = true })
  :wait()
assert(result.code == 0, result.stderr)
git("config", "user.name", "ANSI test")
git("config", "user.email", "ansi-test@example.invalid")
vim.fn.writefile({ "initial" }, root .. "/tracked")
git("add", "tracked")
git("commit", "-m", "Initial test commit")
local initial = git("rev-parse", "HEAD")
git("remote", "add", "origin", root)
git("update-ref", "refs/remotes/origin/main", initial)
git("config", "branch.main.remote", "origin")
git("config", "branch.main.merge", "refs/heads/main")
vim.cmd.edit(vim.fn.fnameescape(root .. "/tracked"))

local system = vim.system
local completed = 0
local started = 0
rawset(vim, "system", function(args, options, callback)
  if args[5] == "status" then
    started = started + 1
    return system(args, options, function(output)
      callback(output)
      vim.schedule(function()
        completed = completed + 1
      end)
    end)
  end
  return system(args, options, callback)
end)
local color = require("lem.git_status").color
for _ = 1, 20 do
  color()
end
assert(started == 1, "Redraws launch duplicate Git jobs")
local function check_status(expected)
  local previous = completed
  assert(
    vim.wait(3000, function()
      local current = color()
      return completed > previous and current.fg == expected and current.bg == 0
    end, 20),
    "Git status does not produce ANSI color " .. expected
  )
end
check_status(2)
vim.fn.writefile({ "untracked" }, root .. "/new")
check_status(1)
git("add", "new")
check_status(1)
git("commit", "-m", "Add test file")
check_status(4)
local ahead = git("rev-parse", "HEAD")
git("update-ref", "refs/remotes/origin/main", ahead)
check_status(2)
git("update-ref", "refs/heads/main", initial)
git("update-index", "--force-remove", "new")
vim.fn.delete(root .. "/new")
check_status(3)
git("commit", "--allow-empty", "-m", "Divergent test commit")
check_status(4)
vim.fn.writefile({ "modified" }, root .. "/tracked")
check_status(1)
rawset(vim, "system", system)

vim.cmd.enew()
local outside = vim.fn.tempname()
vim.fn.mkdir(outside, "p")
vim.cmd.lcd(vim.fn.fnameescape(outside))
assert(color().fg == 8, "A buffer outside Git does not use gray")
print(
  "Status-line colors: diagnostic severities and zero counts; clean, untracked, staged, ahead, behind, diverged, dirty Git states"
)
