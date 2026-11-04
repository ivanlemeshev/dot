local M = {}
local configured = false

local function frame(lines, under)
  local first = under and 2 or 1
  local width = 0
  for index = first, #lines do
    local text = ""
    for _, chunk in ipairs(lines[index]) do
      text = text .. chunk[1]
    end
    width = math.max(width, vim.fn.strdisplaywidth(text))
  end

  local border = "FloatBorder"
  local result = {}
  if under then
    result[1] = lines[1]
  end
  result[#result + 1] =
    { { "┌" .. string.rep("─", width + 2) .. "┐", border } }
  for index = first, #lines do
    local row = { { "│ ", border } }
    local text = ""
    for _, chunk in ipairs(lines[index]) do
      row[#row + 1] = chunk
      text = text .. chunk[1]
    end
    row[#row + 1] = {
      string.rep(" ", width - vim.fn.strdisplaywidth(text)) .. " │",
      border,
    }
    result[#result + 1] = row
  end
  result[#result + 1] =
    { { "└" .. string.rep("─", width + 2) .. "┘", border } }
  return result
end

function M.setup()
  if configured then
    return
  end
  configured = true

  -- NOTE: The plugin has no full-frame option for its virtual text.
  local virtual_text = require("tiny-inline-diagnostic.virtual_text")
  local single = virtual_text.from_diagnostic
  local multiple = virtual_text.from_diagnostics
  local collecting = false

  virtual_text.from_diagnostic = function(...)
    local lines, offset, under = single(...)
    if collecting then
      return lines, offset, under
    end
    return frame(lines, under), offset, under
  end

  virtual_text.from_diagnostics = function(...)
    collecting = true
    local ok, lines, offset, under = pcall(multiple, ...)
    collecting = false
    if not ok then
      error(lines)
    end
    return frame(lines, under), offset, under
  end
end

return M
