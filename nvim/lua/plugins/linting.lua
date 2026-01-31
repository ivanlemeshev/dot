return {
  "mfussenegger/nvim-lint",
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
        cmd = "golangci-lint",
        append_fname = false,
        args = {
          "run",
          "--output.json.path=stdout",
          "--issues-exit-code=0",
          "--show-stats=false",
          "--path-mode=abs",
          function()
            local bufname = vim.api.nvim_buf_get_name(0)
            local go_mod_dir = vim.fs.root(0, "go.mod")
            if go_mod_dir then
              -- Return relative path from go.mod directory
              return bufname:sub(#go_mod_dir + 2)
            end
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
            vim.notify("golangci-lint error: " .. output, vim.log.levels.ERROR)
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

    -- Wrap try_lint to set cwd for Go files
    local original_try_lint = lint.try_lint
    lint.try_lint = function(names, opts)
      opts = opts or {}
      if vim.bo.filetype == "go" then
        opts.cwd = vim.fs.root(0, "go.mod") or vim.fn.getcwd()
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
