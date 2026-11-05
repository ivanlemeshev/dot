local M = {}
local cache = {}

function M.color()
  local theme = require("lem.theme")
  local path = vim.api.nvim_buf_get_name(0)
  local directory = path ~= "" and path or vim.uv.cwd()
  local root = directory and vim.fs.root(directory, ".git")
  if not root then
    return { fg = theme.git.ignored, bg = theme.statusline.section_bg }
  end

  local entry = cache[root] or { state = "ignored" }
  cache[root] = entry
  local now = vim.uv.hrtime() / 1000000
  if
    not entry.running and (not entry.updated or now - entry.updated >= 1000)
  then
    entry.running = true
    entry.updated = now
    -- NOTE: Git runs outside the status-line redraw and uses local upstream refs.
    vim.system({
      "git",
      "--no-optional-locks",
      "-C",
      root,
      "status",
      "--porcelain=v2",
      "--branch",
      "--untracked-files=normal",
    }, {
      text = true,
      env = { GIT_OPTIONAL_LOCKS = "0" },
    }, function(result)
      vim.schedule(function()
        entry.running = false
        entry.state = "ignored"
        if result.code == 0 then
          local ahead, behind =
            result.stdout:match("# branch%.ab %+(%d+) %-(%d+)")
          if
            result.stdout:match("\n[12u?] ")
            or result.stdout:match("^[12u?] ")
          then
            entry.state = "dirty"
          elseif tonumber(ahead or "0") > 0 then
            entry.state = "ahead"
          elseif tonumber(behind or "0") > 0 then
            entry.state = "behind"
          else
            entry.state = "clean"
          end
        end
        vim.cmd.redrawstatus()
      end)
    end)
  end
  return { fg = theme.git[entry.state], bg = theme.statusline.section_bg }
end

return M
