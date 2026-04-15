vim.pack.add({
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    name = "fzf-lua",
    version = "main",
  },
}, {
  load = false, -- Load on first picker use
  confirm = false, -- Install without confirmation
})

local colorscheme = require("lem.colorscheme")
local helpers = require("config.helpers")
local M = {}
local configured = false

local function clipboard_cmd()
  if vim.fn.has("mac") == 1 then
    return "pbcopy"
  elseif vim.fn.executable("wl-copy") == 1 then
    return "wl-copy" -- Wayland
  elseif vim.fn.executable("xclip") == 1 then
    return "xclip -selection clipboard"
  elseif vim.fn.executable("xsel") == 1 then
    return "xsel --clipboard --input"
  elseif vim.fn.has("wsl") == 1 then
    return "clip.exe" -- WSL → Windows clipboard
  else
    return nil
  end
end

function M.fzf()
  helpers.packadd("fzf-lua")

  local fzf = require("fzf-lua")

  if configured then
    return fzf
  end

  local copy = clipboard_cmd()

  fzf.setup({
    fzf_colors = colorscheme.fzf_lua_colors,
    fzf_opts = {
      ["--multi"] = true,
    },
    winopts = {
      fullscreen = true, -- Let's try it
      border = "single",
      height = 0.90,
      width = 0.95,
      preview = {
        border = "single",
        layout = "vertical",
        vertical = "down:70%",
      },
    },
    files = {
      hidden = true,
      fd_opts = "--color=never --hidden --type f --type l --exclude .git",
    },
    grep = {
      hidden = true,
      rg_opts = table.concat({
        "--column",
        "--line-number",
        "--no-heading",
        "--color=always",
        "--fixed-strings",
        "--smart-case",
        "--max-columns=4096",
        "-e",
      }, " "),
    },
    keymap = {
      fzf = {
        ["ctrl-y"] = copy
            and ("execute-silent(printf '%s\\n' {+} | " .. copy .. ")")
          or nil,
      },
    },
  })

  configured = true

  return fzf
end

helpers.nmap("<leader>ff", function()
  M.fzf().files()
end, "Search: find files")

helpers.nmap("<leader>fp", function()
  M.fzf().live_grep({
    file_ignore_patterns = {
      "node_modules",
      "%.git/",
      "%.git$",
      ".venv",
      "vendor",
    },
    hidden = true,
  })
end, "Search: find in project files")

helpers.nmap("<leader>fd", function()
  M.fzf().diagnostics_workspace()
end, "Search: find in diagnostics")

helpers.nmap("<leader>fb", function()
  M.fzf().buffers({
    no_header_i = true,
    ignore_current_buffer = false,
    sort_lastused = false,
    filter = function(bufnr)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      local bt = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
      local name = vim.api.nvim_buf_get_name(bufnr)

      return ft ~= "NvimTree"
        and ft ~= "neo-tree"
        and bt ~= "nofile"
        and not name:match("NvimTree_")
    end,
  })
end, "Search: find in opened buffers")

helpers.nmap("<leader>fc", function()
  M.fzf().blines()
end, "Search: find in the current buffer")

helpers.nmap("<leader>fh", function()
  M.fzf().helptags()
end, "Search: find in help")

helpers.nmap("<leader>fg", function()
  M.fzf().live_grep({
    hidden = true,
    no_ignore = true,
  })
end, "Search: find in all files")

return M
