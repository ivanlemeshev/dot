-- Enable undercurl support in terminals that support it but lack the terminfo
-- capability (e.g. Windows Terminal).
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Disable netrw, the built-in file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Always show the sign column to prevent text shifting when signs appear.
vim.opt.signcolumn = "yes:1"

-- Disable cursor blinking in the terminal mode.
vim.opt.guicursor =
  "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block-blinkon0-blinkoff0-TermCursor"

-- Allow the backspace key to delete over auto-indent, line breaks (enter), and
-- the start of insert; essentially making backspace work more like it does
-- in other modern text editors.
vim.opt.backspace = "2"

-- Keep 10 lines visible above and below the cursor when scrolling.
vim.opt.scrolloff = 10

-- Display incomplete commands in the bottom right corner of the window. This
-- feature is useful for seeing which keys you have pressed during a command
-- sequence, helping you understand what action is being performed or if you've
-- made a mistake in a multi-key command.
vim.opt.showcmd = true

-- Always display the status line, regardless of whether there are multiple
-- windows open. This is useful for constantly showing information like the
-- current mode, file name, or any other status line integration.
vim.opt.laststatus = 3

-- Automatically read the file from disk when it has been changed outside of
-- Neovim, ensuring that the file's contents are always up to date with its
-- external changes.
vim.opt.autoread = true

-- Auto-reload buffers when files change externally (e.g., git operations)
local reload_augroup =
  vim.api.nvim_create_augroup("auto-reload", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = reload_augroup,
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end,
})

-- Automatically save changes to a file when you switch to another file or
-- before running certain commands that would normally require saving the file
-- first.
vim.opt.autowrite = true

-- Automatically save changes to all modified buffers without prompting the
-- user. This can be particularly useful for preventing data loss and ensuring
-- that all changes are consistently saved.
vim.opt.autowriteall = true

-- Highlight the line where the cursor is currently positioned.
vim.opt.cursorline = true

-- Display the line numbers next to each line.
vim.opt.number = true

-- Disable relative line numbers.
vim.opt.relativenumber = false

-- Display whitespace characters using special symbols.
vim.opt.list = true

-- Display tabs, whitespaces, the end of the line.
vim.opt.listchars = {
  eol = " ",
  tab = "  ",
  space = ".",
  multispace = ".",
  lead = ".",
  leadmultispace = ".",
  trail = ".",
  nbsp = ".",
}

local visual_list_augroup =
  vim.api.nvim_create_augroup("visual-list-toggle", { clear = true })

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_list_augroup,
  pattern = "*:[vV\22]*",
  callback = function()
    vim.w._list_before_visual = vim.wo.list
    vim.wo.list = false
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_list_augroup,
  pattern = "[vV\22]*:*",
  callback = function()
    if vim.w._list_before_visual == nil then
      return
    end

    vim.wo.list = vim.w._list_before_visual
    vim.w._list_before_visual = nil
  end,
})

-- Ensure files end with a newline character.
vim.opt.fixeol = true

-- Sync the system clipboard with the internal Neovim clipboard.
vim.opt.clipboard = "unnamed,unnamedplus"

-- Wrap lines at the edge of the window.
vim.opt.wrap = true

-- Do not split words when wrapping lines.
vim.opt.linebreak = true

-- Enable the mouse in all modes.
vim.opt.mouse = "a"

-- Case-insensitive search, unless uppercase is used.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Highlight search matches.
vim.opt.hlsearch = true

-- Show matches as you type.
vim.opt.incsearch = true

-- Persistent undo (survives closing the file).
vim.opt.undofile = true

-- New splits open below and to the right.
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Global default indentation (fallback for filetypes not explicitly configured).
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

-- Copy the indent from the previous line when starting a new line.
vim.opt.autoindent = true

-- Do not create backup files.
vim.opt.swapfile = false

-- Hide ~ end-of-buffer filler characters and use line chars for window separators.
vim.opt.fillchars:append({
  eob = " ",
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})

-- Enable true color support in the terminal.
vim.opt.termguicolors = true

-- Faster key sequence timeout (snappier escape and leader combos).
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

-- Reduce update time (faster CursorHold events, gitsigns, diagnostics).
vim.opt.updatetime = 250

-- Limit completion menu height.
vim.opt.pumheight = 10

-- Don't show mode in command line (lualine already shows it).
vim.opt.showmode = false

-- Reduce file messages noise.
vim.opt.shortmess:append("sI")

-- Disable standard spell checking (Harper is used instead).
vim.opt.spell = false

-- Set the default file formats to Unix and DOS, allowing Neovim to recognize and handle files with either line ending
-- style appropriately.
vim.opt.fileformats = "unix,dos"

-- Configure clipboard integration for Windows Subsystem for Linux (WSL) to allow seamless copying and pasting between
-- WSL and the Windows clipboard. This setup uses the `clip.exe` utility for copying and PowerShell commands for
-- pasting, ensuring that line endings are handled correctly by removing carriage return characters (`\r`).
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] = 'powershell.exe -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] = 'powershell.exe -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

-- Set the file format to Unix (LF) before saving any file, ensuring consistent line endings across different platforms
-- and preventing issues with files that may be edited on both Unix-like systems and Windows.
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[set ff=unix]],
})

-- Disable diagnostic virtual text in buffer.
vim.diagnostic.config({
  virtual_text = false,
})

-- Set diagnostic signs.
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

local large_file_max_size = 2 * 1024 * 1024

-- Trim trailing whitespace on save.
local trim_augroup =
  vim.api.nvim_create_augroup("trim-whitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = trim_augroup,
  pattern = "*",
  callback = function()
    if vim.b.large_file then
      return
    end

    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})

local function get_file_size(path)
  local size = vim.fn.getfsize(path)
  if size < 0 then
    return nil
  end

  return size
end

local function is_large_file(path)
  if path == "" or vim.fn.isdirectory(path) == 1 then
    return false
  end

  local size = get_file_size(path)
  return size ~= nil and size >= large_file_max_size
end

local function apply_large_file_mode(buf)
  vim.b[buf].large_file = true
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  vim.bo[buf].bufhidden = "unload"
  vim.bo[buf].readonly = true
  vim.api.nvim_set_option_value("wrap", false, { buf = buf })
  vim.api.nvim_set_option_value("linebreak", false, { buf = buf })
  vim.api.nvim_set_option_value("number", false, { buf = buf })
  vim.api.nvim_set_option_value("relativenumber", false, { buf = buf })
  vim.api.nvim_set_option_value("cursorline", false, { buf = buf })
  vim.api.nvim_set_option_value("foldmethod", "manual", { buf = buf })
  vim.api.nvim_set_option_value("foldenable", false, { buf = buf })
  vim.api.nvim_set_option_value("spell", false, { buf = buf })
  vim.api.nvim_set_option_value("list", false, { buf = buf })
end

local large_file_augroup =
  vim.api.nvim_create_augroup("large-files", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = large_file_augroup,
  pattern = "*",
  callback = function(args)
    if is_large_file(args.match) then
      apply_large_file_mode(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = large_file_augroup,
  pattern = "*",
  callback = function(args)
    if not vim.b[args.buf].large_file then
      return
    end

    vim.bo[args.buf].syntax = "off"
    vim.diagnostic.enable(false, { bufnr = args.buf })

    local ok, _ = pcall(vim.treesitter.stop, args.buf)
    if not ok then
      vim.schedule(function()
        pcall(vim.treesitter.stop, args.buf)
      end)
    end
  end,
})

-- Set options based on the file type.
-- You can check the file type using command :echo &filetype

-- Shell script settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sh",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Python settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Go settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gosum" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- C settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- C++ settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Zig settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- YAML settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "yaml", "yaml.ansible" },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Dockerfile settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dockerfile",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Makefile settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- JSON settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Lua settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- TOML settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- config.fish settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fish",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- .vimrc settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vim",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Terraform settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Protobuf settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "proto",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- TypeScript settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescript",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Markdown settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- C# settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- CSV settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    -- Enable csvview by default
    vim.cmd("CsvViewEnable")
  end,
})

-- PowerShell script settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ps1",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Kulala UI settings
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "kulala://*",
  callback = function()
    vim.opt_local.foldenable = false
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "kulala://*",
  callback = function()
    vim.diagnostic.enable(false, { bufnr = 0 })
  end,
})

-- Open binary files as a read-only hex buffer instead of rendering raw bytes
-- as if they were plain text.
local binary_extensions = {
  ["7z"] = true,
  a = true,
  bin = true,
  bmp = true,
  class = true,
  db = true,
  dll = true,
  dylib = true,
  exe = true,
  gif = true,
  gz = true,
  icns = true,
  ico = true,
  jar = true,
  jpeg = true,
  jpg = true,
  o = true,
  pdf = true,
  png = true,
  pyc = true,
  pyd = true,
  pyo = true,
  so = true,
  sqlite = true,
  sqlite3 = true,
  tar = true,
  ttf = true,
  wasm = true,
  webp = true,
  xz = true,
  zip = true,
}

local function read_file_chunk(path, size)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end

  local data = file:read(size)
  file:close()
  return data
end

local function is_known_binary_extension(path)
  local extension = vim.fn.fnamemodify(path, ":e"):lower()
  return extension ~= "" and binary_extensions[extension] == true
end

local function has_nul_byte(path)
  local chunk = read_file_chunk(path, 1024)
  return chunk ~= nil and chunk:find("\0", 1, true) ~= nil
end

local function should_open_as_binary(path)
  if path == "" or vim.fn.isdirectory(path) == 1 then
    return false
  end

  return is_known_binary_extension(path) or has_nul_byte(path)
end

local function open_buffer_as_hex(buf)
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  vim.bo[buf].binary = true

  if vim.fn.executable("xxd") == 1 then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("%!xxd -g 1")
    end)
    vim.bo[buf].filetype = "xxd"
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].modified = false
end

local binary_augroup =
  vim.api.nvim_create_augroup("binary-buffers", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  group = binary_augroup,
  pattern = "*",
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    if not should_open_as_binary(args.match) then
      return
    end

    open_buffer_as_hex(args.buf)
  end,
})

local function ansible_yaml_filetype(path)
  local normalized = vim.fs.normalize(path)

  if normalized:match("/ansible/") then
    return "yaml.ansible"
  end
  if normalized:match("/playbooks/") then
    return "yaml.ansible"
  end
  if normalized:match("/roles/.+/(tasks|handlers|vars|defaults|meta)/") then
    return "yaml.ansible"
  end
  if normalized:match("/group_vars/") or normalized:match("/host_vars/") then
    return "yaml.ansible"
  end

  return "yaml"
end

vim.filetype.add({
  extension = {
    yml = ansible_yaml_filetype,
    yaml = ansible_yaml_filetype,
  },
})
