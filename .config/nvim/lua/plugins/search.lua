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

local helpers = require("config.helpers")
local theme = require("lem.theme")
local M = {}
local configured = false

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return string.format(
    "%d,%d,%d",
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16)
  )
end

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
    fzf_colors = theme.fzf,
    hls = {
      normal = "FzfLuaNormal",
      border = "FzfLuaBorder",
      title = "FzfLuaTitle",
      title_flags = "FzfLuaTitleFlags",
      backdrop = "FzfLuaBackdrop",
      preview_normal = "FzfLuaPreviewNormal",
      preview_border = "FzfLuaPreviewBorder",
      preview_title = "FzfLuaPreviewTitle",
      cursor = "FzfLuaCursor",
      cursorline = "FzfLuaCursorLine",
      cursorlinenr = "FzfLuaCursorLineNr",
      search = "FzfLuaSearch",
      scrollborder_e = "FzfLuaScrollBorderEmpty",
      scrollborder_f = "FzfLuaScrollBorderFull",
      scrollfloat_e = "FzfLuaScrollFloatEmpty",
      scrollfloat_f = "FzfLuaScrollFloatFull",
      help_normal = "FzfLuaHelpNormal",
      help_border = "FzfLuaHelpBorder",
      header_bind = "FzfLuaHeaderBind",
      header_text = "FzfLuaHeaderText",
      path_colnr = "FzfLuaPathColNr",
      path_linenr = "FzfLuaPathLineNr",
      buf_name = "FzfLuaBufName",
      buf_id = "FzfLuaBufId",
      buf_nr = "FzfLuaBufNr",
      buf_linenr = "FzfLuaBufLineNr",
      buf_flag_cur = "FzfLuaBufFlagCur",
      buf_flag_alt = "FzfLuaBufFlagAlt",
      tab_title = "FzfLuaTabTitle",
      tab_marker = "FzfLuaTabMarker",
      dir_icon = "FzfLuaDirIcon",
      dir_part = "FzfLuaDirPart",
      file_part = "FzfLuaFilePart",
      live_prompt = "FzfLuaLivePrompt",
      live_sym = "FzfLuaLiveSym",
      cmd_ex = "FzfLuaCmdEx",
      cmd_buf = "FzfLuaCmdBuf",
      cmd_global = "FzfLuaCmdGlobal",
      fzf_normal = "FzfLuaFzfNormal",
      fzf_cursorline = "FzfLuaFzfCursorLine",
      fzf_match = "FzfLuaFzfMatch",
      fzf_border = "FzfLuaFzfBorder",
      fzf_scrollbar = "FzfLuaFzfScrollbar",
      fzf_separator = "FzfLuaFzfSeparator",
      fzf_gutter = "FzfLuaFzfGutter",
      fzf_header = "FzfLuaFzfHeader",
      fzf_info = "FzfLuaFzfInfo",
      fzf_pointer = "FzfLuaFzfPointer",
      fzf_marker = "FzfLuaFzfMarker",
      fzf_spinner = "FzfLuaFzfSpinner",
    },
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
        "--colors",
        "path:fg:" .. hex_to_rgb(theme.fzf.fg),
        "--colors",
        "line:fg:" .. hex_to_rgb(theme.fzf.fg),
        "--colors",
        "column:fg:" .. hex_to_rgb(theme.fzf.fg),
        "--colors",
        "match:fg:" .. hex_to_rgb(theme.fzf.hl),
        "--colors",
        "match:style:bold",
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
