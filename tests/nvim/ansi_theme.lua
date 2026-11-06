-- Run with: nvim --clean -l tests/nvim/ansi_theme.lua
vim.opt.rtp:prepend(vim.fn.getcwd() .. "/.config/nvim")

local definitions = {}
local set_hl = vim.api.nvim_set_hl
vim.api.nvim_set_hl = function(namespace, name, options)
	definitions[name] = true
	return set_hl(namespace, name, options)
end

local theme = require("lem.theme")
theme.setup()
vim.api.nvim_set_hl = set_hl

local function highlight(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function check(condition, message)
	assert(condition, message)
end

local first = {}
local used = {}
for name in pairs(definitions) do
	local attributes = highlight(name)
	first[name] = attributes
	for _, key in ipairs({ "ctermfg", "ctermbg" }) do
		local index = attributes[key]
		if index ~= nil then
			check(index >= 0 and index <= 15, name .. " uses an index outside ANSI 16")
			used[index] = true
		end
	end
	for _, key in ipairs({ "fg", "bg", "sp" }) do
		check(attributes[key] == nil, name .. " uses an RGB color")
	end
	check(not (attributes.cterm or {}).bold or name == "CursorLineNr", name .. " uses terminal bold")
end
check(used[0] and used[15], "The theme omits a text or surface role")
check(used[2] and used[9], "The theme omits normal or bright colors")
check(highlight("Normal").ctermfg == 15, "Main text does not use bright white")
check(used[8], "The theme omits bright black for secondary text")
for name in pairs({
	EndOfBuffer = true,
	FoldColumn = true,
	NonText = true,
	SpecialKey = true,
	Whitespace = true,
	IblIndent = true,
	IblWhitespace = true,
	NvimTreeIndentMarker = true,
}) do
	check(highlight(name).ctermfg == 8, name .. " does not use bright black")
end
for _, name in ipairs({ "Comment", "SpecialComment" }) do
	check(highlight(name).ctermfg == 8, name .. " does not use bright black")
end

local fish_config = table.concat(vim.fn.readfile(".config/fish/conf.d/fzf_colors.fish"), "\n")
local fish_colors = fish_config:match('set %-l colors "([^"]+)"')
check(fish_colors == theme.fzf_colors(), "Fish and Neovim use different fzf colors")
check(fish_colors:find("fg+:0:strip", 1, true), "Selected rows preserve incoming text colors")
check(fish_colors:find("hl+:0:strip:underline", 1, true), "Selected matches lose contrast")
check(fish_config:find('"--highlight-line"', 1, true), "Fish does not highlight the current result row")
check(fish_config:find('"--no-bold"', 1, true), "Fish can promote ANSI colors through bold")

check(fish_colors:find("bg+:12", 1, true), "fzf uses the wrong selection background")
check(fish_colors:find("selected-fg:0:strip", 1, true), "Marked rows preserve unreadable input colors")
check(theme.fzf.pointer == 0 and theme.fzf.marker == 0, "Selection indicators have low contrast")

check(not vim.o.termguicolors, "The theme enables true color")
for _, name in ipairs({
	"Normal",
	"StatusLine",
	"StatusLineNC",
	"WinBar",
	"TabLine",
}) do
	check(highlight(name).ctermbg == 0, name .. " uses a light surface")
end
check(highlight("CursorLine").ctermbg == nil and highlight("CursorLine").ctermfg == nil, "The cursor line has a highlight")
check(highlight("CursorLineNr").ctermbg == nil, "The active line number has a background")
check(highlight("CursorLineNr").ctermfg == 11 and highlight("CursorLineNr").cterm.bold, "The active line number is not yellow and bold")

for _, name in ipairs({
	"LspReferenceText",
	"LspReferenceRead",
	"LspReferenceWrite",
}) do
	local attributes = highlight(name)
	check(attributes.ctermfg == nil and attributes.ctermbg == nil, name .. " hides syntax colors")
	check((attributes.cterm or {}).underline, name .. " has no terminal underline")
end
check(theme.ui.search_bg ~= theme.ui.cur_search_bg, "Search states use the same index")
check(theme.ui.search_bg % 8 ~= theme.ui.cur_search_bg % 8, "Search states differ only in brightness")
for _, name in ipairs({
	"Visual",
	"VisualNOS",
	"PmenuSel",
	"PmenuKindSel",
	"PmenuExtraSel",
	"NvimTreeCursorLine",
	"FzfLuaCursorLine",
	"FzfLuaFzfCursorLine",
	"QuickFixLine",
}) do
	local attributes = highlight(name)
	check(attributes.ctermfg == 0 and attributes.ctermbg == 12, name .. " has inconsistent selection colors")
end


theme.setup()
for name, attributes in pairs(first) do
	check(vim.deep_equal(attributes, highlight(name)), name .. " changes after repeated setup")
end
dofile(".config/nvim/lua/config/options.lua")
dofile(".config/nvim/lua/config/autocmds.lua")
check(vim.o.guicursor:find("a:blinkon0", 1, true), "The cursor can blink")
check(vim.wo.cursorline and vim.wo.cursorlineopt == "number", "The active line number is not the only highlighted area")
for _, event in ipairs({ "InsertEnter", "InsertLeave" }) do
	vim.api.nvim_exec_autocmds(event, {})
	check(vim.wo.cursorline and vim.wo.cursorlineopt == "number", event .. " changes the line-number highlight")
end

