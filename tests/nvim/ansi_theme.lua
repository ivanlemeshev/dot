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
	check(not (attributes.cterm or {}).bold, name .. " uses terminal bold")
end
for index = 0, 15 do
	check(used[index], "ANSI index " .. index .. " has no role")
end

local fish_config = table.concat(vim.fn.readfile(".config/fish/conf.d/fzf_colors.fish"), "\n")
local fish_colors = fish_config:match('set %-l colors "([^"]+)"')
check(fish_colors == theme.fzf_colors(), "Fish and Neovim use different fzf colors")
check(fish_colors:find("fg+:0:strip", 1, true), "Selected rows preserve incoming text colors")
check(fish_colors:find("hl+:0:strip:underline", 1, true), "Selected matches lose contrast")
check(fish_config:find('"--highlight-line"', 1, true), "Fish does not highlight the current result row")
check(fish_config:find('"--no-bold"', 1, true), "Fish can promote ANSI colors through bold")

check(fish_colors:find("bg+:8", 1, true), "fzf uses the wrong selection background")

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
check(highlight("CursorLine").ctermbg == 8 and highlight("CursorLine").ctermfg == 0, "The cursor line has low contrast")
check(highlight("CursorLineNr").ctermbg == nil, "The active line number has a background")

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
	check(attributes.ctermfg == 0 and attributes.ctermbg == 8, name .. " has inconsistent selection colors")
end

local settings = vim.json.decode(table.concat(vim.fn.readfile("windows/terminal/settings.json"), "\n"))
local palette = settings.schemes[1]
local keys = {
	"black",
	"red",
	"green",
	"yellow",
	"blue",
	"purple",
	"cyan",
	"white",
	"brightBlack",
	"brightRed",
	"brightGreen",
	"brightYellow",
	"brightBlue",
	"brightPurple",
	"brightCyan",
	"brightWhite",
}
local luminance = {}
for index, key in ipairs(keys) do
	local color = palette[key]
	local value = 0
	for channel, weight in ipairs({ 0.2126, 0.7152, 0.0722 }) do
		local offset = 2 * channel
		local component = tonumber(color:sub(offset, offset + 1), 16) / 255
		local linear = component <= 0.04045 and component / 12.92 or ((component + 0.055) / 1.055) ^ 2.4
		value = value + linear * weight
	end
	luminance[index - 1] = value
end

local minimum = math.huge
local count = 0
for name, attributes in pairs(first) do
	-- NOTE: Inverse diagnostic groups draw empty corners with the background color.
	if attributes.ctermfg ~= nil and not name:match("^TinyInlineInv") then
		local foreground = luminance[attributes.ctermfg]
		local background = luminance[attributes.ctermbg or theme.ui.bg]
		local ratio = (math.max(foreground, background) + 0.05) / (math.min(foreground, background) + 0.05)
		check(ratio >= 4.4, name .. " has low contrast in " .. palette.name)
		minimum = math.min(minimum, ratio)
		count = count + 1
	end
end

for _, mode in pairs(theme.lualine_theme) do
	for _, section in pairs(mode) do
		check(section.fg >= 0 and section.fg <= 15, "Lualine uses a foreground outside ANSI 16")
		check(section.bg >= 0 and section.bg <= 15, "Lualine uses a background outside ANSI 16")
	end
end

theme.setup()
for name, attributes in pairs(first) do
	check(vim.deep_equal(attributes, highlight(name)), name .. " changes after repeated setup")
end
dofile(".config/nvim/lua/config/options.lua")
dofile(".config/nvim/lua/config/autocmds.lua")
check(vim.wo.cursorline, "The cursor line is disabled")
check(vim.wo.cursorlineopt:find("line", 1, true), "The cursor line marks only its number")
for _, event in ipairs({ "InsertEnter", "InsertLeave" }) do
	vim.api.nvim_exec_autocmds(event, {})
	check(vim.wo.cursorline, event .. " hides the cursor line")
end

print(
	string.format(
		"ANSI theme: %d groups; all 16 indices; %d text pairs; minimum contrast %.2f:1 in %s",
		vim.tbl_count(first),
		count,
		minimum,
		palette.name
	)
)
