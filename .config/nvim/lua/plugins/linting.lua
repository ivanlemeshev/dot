local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/mfussenegger/nvim-lint",
    name = "nvim-lint",
    version = "master",
  },
}, {
  load = false,
  confirm = false,
})

local function golangci_cmd()
  local project_root = vim.fs.root(0, "go.mod")
  if project_root then
    for _, path in ipairs({
      project_root .. "/temp/bin/golangci-lint",
      project_root .. "/bin/golangci-lint",
      project_root .. "/.bin/golangci-lint",
      project_root .. "/tools/bin/golangci-lint",
    }) do
      if vim.fn.filereadable(path) == 1 then
        return path
      end
    end
  end

  return "golangci-lint"
end

local function parse_golangci_output(output, bufnr)
  if output == "" then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, output)
  if not ok then
    vim.schedule(function()
      vim.notify("golangci-lint error: " .. output, vim.log.levels.ERROR)
    end)
    return {}
  end

  if decoded.Issues == nil or type(decoded.Issues) == "userdata" then
    return {}
  end

  local severities = {
    convention = vim.diagnostic.severity.HINT,
    error = vim.diagnostic.severity.ERROR,
    refactor = vim.diagnostic.severity.INFO,
    warning = vim.diagnostic.severity.WARN,
  }

  local diagnostics = {}
  local curfile = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))

  for _, item in ipairs(decoded.Issues) do
    if curfile == vim.fs.normalize(item.Pos.Filename) then
      table.insert(diagnostics, {
        lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
        col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
        end_lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
        end_col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
        severity = severities[item.Severity] or severities.warning,
        source = item.FromLinter,
        message = item.Text,
      })
    end
  end

  return diagnostics
end

local function golangci_linter()
  return {
    cmd = golangci_cmd,
    append_fname = false,
    args = {
      "run",
      "--output.json.path=stdout",
      "--issues-exit-code=0",
      "--show-stats=false",
      "--path-mode=abs",
      function()
        return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
      end,
    },
    stream = "both",
    ignore_exitcode = true,
    parser = parse_golangci_output,
  }
end

local function setup_try_lint(lint)
  local original_try_lint = lint.try_lint

  lint.try_lint = function(names, opts)
    if vim.b.large_file then
      return
    end

    opts = opts or {}
    if vim.bo.filetype == "go" then
      local go_root = vim.fs.root(0, "go.mod")
      if not go_root then
        return
      end
      opts.cwd = go_root
    end

    return original_try_lint(names, opts)
  end
end

helpers.load_on(
  { "BufReadPre", "BufNewFile" },
  "pack-linting",
  "nvim-lint",
  function()
    local lint = require("lint")

    lint.linters.golangcilint_custom = golangci_linter()
    lint.linters_by_ft = {
      dockerfile = { "hadolint" },
      go = { "golangcilint_custom" },
      markdown = { "markdownlint" },
      terraform = { "tflint", "tfsec" },
      ["yaml.ansible"] = { "ansible_lint" },
    }

    setup_try_lint(lint)

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = helpers.augroup("lint"),
      callback = function()
        lint.try_lint()
      end,
    })

    helpers.nmap("<leader>l", function()
      lint.try_lint()
    end, "Trigger linting for current file")
  end
)
