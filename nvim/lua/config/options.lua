-- NOTE: Some terminals need explicit undercurl escape sequences.
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- NOTE: NvimTree replaces the built-in file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- NOTE: A fixed sign column prevents text movement when signs appear.
vim.opt.signcolumn = "yes:1"

vim.opt.guicursor =
  "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block,a:blinkon0"

vim.opt.backspace = "2"

vim.opt.scrolloff = 10

vim.opt.showcmd = true

vim.opt.laststatus = 3

vim.opt.autoread = true

-- NOTE: Buffer changes can trigger automatic saves.
vim.opt.autowrite = true

vim.opt.autowriteall = true

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.colorcolumn = ""

vim.opt.number = true

vim.opt.relativenumber = false

vim.opt.list = true

vim.opt.listchars = {
  trail = "·",
  tab = "› ",
  nbsp = "␣",
}

vim.opt.fixeol = true

vim.opt.clipboard = "unnamed,unnamedplus"

vim.opt.wrap = true

vim.opt.linebreak = true

vim.opt.mouse = "a"

vim.opt.pumborder = "single"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hlsearch = true

vim.opt.incsearch = true

vim.opt.undofile = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.autoindent = true

vim.opt.swapfile = false

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

vim.opt.termguicolors = false

vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10

vim.opt.updatetime = 250

vim.opt.pumheight = 10

-- NOTE: The status line shows the current mode.
vim.opt.showmode = false

vim.opt.shortmess:append("sI")

-- NOTE: Harper supplies the spelling checks.
vim.opt.spell = false

vim.opt.fileformats = "unix,dos"

-- NOTE: Windows clipboard output needs LF line endings in WSL.
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
