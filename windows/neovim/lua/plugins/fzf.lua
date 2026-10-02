vim.pack.add({
  {
    src = "https://github.com/ibhagwan/fzf-lua",
    name = "fzf-lua",
    version = "main",
  },
}, {
  load = true,
  confirm = false,
})

local fzf = require("fzf-lua")
local theme = require("config.theme")

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return string.format(
    "%d,%d,%d",
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16)
  )
end

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
    fullscreen = true,
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
})

local keymaps = {
  { "<leader>ff", fzf.files, "Find files by filename" },
  { "<leader>fb", fzf.buffers, "Find open buffers" },
  {
    "<leader>fg",
    function()
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
    end,
    "Search text across project files",
  },
  {
    "<leader>fd",
    function()
      fzf.diagnostics_workspace()
    end,
    "Find workspace diagnostics",
  },
  { "<leader>fh", fzf.helptags, "Search help tags" },
  { "<leader>fo", fzf.oldfiles, "Find recently opened files" },
  { "<leader>fw", fzf.grep_cword, "Search the word under the cursor" },
  { "<leader>fc", fzf.command_history, "Search command history" },
  { "<leader>fs", fzf.search_history, "Search history" },
  { "<leader>fr", fzf.resume, "Resume the previous search" },
}

for _, keymap in ipairs(keymaps) do
  vim.keymap.set("n", keymap[1], keymap[2], { desc = keymap[3] })
end
