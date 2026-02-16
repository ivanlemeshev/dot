return {
  "mfussenegger/nvim-lint",
  commit = "bcd1a44edbea8cd473af7e7582d3f7ffc60d8e81",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  config = function()
    local lint = require("lint")

    -- Helper function to create custom golangci-lint linter
    local function create_golangci_linter()
      local severities = {
        error = vim.diagnostic.severity.ERROR,
        warning = vim.diagnostic.severity.WARN,
        refactor = vim.diagnostic.severity.INFO,
        convention = vim.diagnostic.severity.HINT,
      }

      return {
        cmd = function()
          -- Try to find project-local golangci-lint (for custom plugins support)
          local project_root = vim.fs.root(0, "go.mod")
          if project_root then
            -- Check common project-local locations
            local candidates = {
              project_root .. "/temp/bin/golangci-lint",
              project_root .. "/bin/golangci-lint",
              project_root .. "/.bin/golangci-lint",
              project_root .. "/tools/bin/golangci-lint",
            }
            for _, path in ipairs(candidates) do
              if vim.fn.filereadable(path) == 1 then
                return path
              end
            end
          end
          -- Fall back to system golangci-lint
          return "golangci-lint"
        end,
        append_fname = false,
        args = {
          "run",
          "--output.json.path=stdout",
          "--issues-exit-code=0",
          "--show-stats=false",
          "--path-mode=abs",
          function()
            local bufname = vim.api.nvim_buf_get_name(0)
            -- Get the directory containing the file (the package directory)
            return vim.fn.fnamemodify(bufname, ":h")
          end,
        },
        stream = "both", -- Capture both stdout and stderr
        ignore_exitcode = true,
        parser = function(output, bufnr, cwd)
          if output == "" then
            return {}
          end

          -- Check if output contains errors (not JSON)
          local ok, decoded = pcall(vim.json.decode, output)
          if not ok then
            -- Failed to parse JSON - likely an error message
            -- Use vim.schedule to safely call vim.notify from callback
            vim.schedule(function()
              vim.notify("golangci-lint error: " .. output, vim.log.levels.ERROR)
            end)
            return {}
          end
          if
            decoded["Issues"] == nil or type(decoded["Issues"]) == "userdata"
          then
            return {}
          end

          local diagnostics = {}
          for _, item in ipairs(decoded["Issues"]) do
            local curfile = vim.api.nvim_buf_get_name(bufnr)
            local curfile_norm = vim.fs.normalize(curfile)

            -- item.Pos.Filename is already absolute due to --path-mode=abs
            local lintedfile_norm = vim.fs.normalize(item.Pos.Filename)

            if curfile_norm == lintedfile_norm then
              local sv = severities[item.Severity] or severities.warning
              table.insert(diagnostics, {
                lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
                col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
                end_lnum = item.Pos.Line > 0 and item.Pos.Line - 1 or 0,
                end_col = item.Pos.Column > 0 and item.Pos.Column - 1 or 0,
                severity = sv,
                source = item.FromLinter,
                message = item.Text,
              })
            end
          end
          return diagnostics
        end,
      }
    end

    -- Register custom golangci-lint linter
    lint.linters.golangcilint_custom = create_golangci_linter()

    -- Wrap try_lint to set cwd for Go files and skip if not in a Go project
    local original_try_lint = lint.try_lint
    lint.try_lint = function(names, opts)
      opts = opts or {}
      if vim.bo.filetype == "go" then
        local go_root = vim.fs.root(0, "go.mod")
        if not go_root then
          -- Skip linting if not in a Go project (no go.mod found)
          return
        end
        opts.cwd = go_root
      end
      return original_try_lint(names, opts)
    end

    lint.linters_by_ft = {
      go = { "golangcilint_custom" },
      dockerfile = { "hadolint" },
      markdown = { "markdownlint" },
      terraform = { "tflint", "tfsec" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
