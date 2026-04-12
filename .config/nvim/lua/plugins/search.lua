vim.pack.add({
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    name = "fzf-lua",
    version = "main",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

local colorscheme = require("lem.colorscheme")
local fzf = require("fzf-lua")

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

local copy = clipboard_cmd()

fzf.setup({
  fzf_colors = colorscheme.fzf_lua_colors,
  fzf_opts = {
    ["--multi"] = true,
  },
  winopts = {
    border = "single",
    preview = {
      border = "single",
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
      "--smart-case",
      "--max-columns=4096",
      "-e",
    }, " "),
  },
  keymap = {
    fzf = {
      ["y"] = copy and ("execute-silent(printf '%s\\n' {+} | " .. copy .. ")") or nil,
    },
  },
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>ff", fzf.files, { desc = "Search: find files", noremap = true, silent = true })

map("n", "<leader>fp", function()
  fzf.live_grep({
    file_ignore_patterns = {
      "node_modules",
      "%.git/",
      "%.git$",
      ".venv",
      "vendor",
    },
    hidden = true,
  })
end, { desc = "Search: find in project files", noremap = true, silent = true })

map(
  "n",
  "<leader>fd",
  fzf.diagnostics_workspace,
  { desc = "Search: find in diagnostics", noremap = true, silent = true }
)

map("n", "<leader>fb", fzf.buffers, { desc = "Search: find in opened buffers", noremap = true, silent = true })

map("n", "<leader>fc", fzf.blines, { desc = "Search: find in the current buffer", noremap = true, silent = true })

map("n", "<leader>fh", fzf.helptags, { desc = "Search: find in help", noremap = true, silent = true })

map("n", "<leader>fg", function()
  fzf.live_grep({
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Search: find in all files", noremap = true, silent = true })
