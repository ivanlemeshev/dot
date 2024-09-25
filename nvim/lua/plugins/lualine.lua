return {
  "nvim-lualine/lualine.nvim",
  event = "VimEnter",
  dependencies = {
    "AndreM222/copilot-lualine",
  },
  config = function()
    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
    }

    local filename = {
      "filename",
      file_status = true,
      path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }

    local copilot = {
      "copilot",
      symbols = {
        status = {
          icons = {
            enabled = "",
            sleep = "", -- auto-trigger disabled
            disabled = "",
            warning = "",
            unknown = "",
          },
        },
      },
    }

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
      update_in_insert = true,
      always_visible = true,
    }

    local diff = {
      "diff",
      colored = false,
      sections = { "added", "modified", "removed" },
      symbols = { added = " ", modified = " ", removed = " " },
    }

    require("lualine").setup({
      options = {
        icons_enabled = true,
        --          
        section_separators = { left = "", right = "" },
        component_separators = { left = "|", right = "|" },
        always_divide_middle = true,
        disabled_filetypes = {
          "neotest-output-panel",
          "neotest-summary",
          "neo-tree",
          "trouble",
        },
      },
      -- +-------------------------------------------------+
      -- | A | B | C                             X | Y | Z |
      -- +-------------------------------------------------+
      sections = {
        lualine_a = { mode },
        lualine_b = { "branch", diff },
        lualine_c = { filename },
        lualine_x = { copilot, diagnostics, "encoding", "filetype" },
        lualine_y = { "location" },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = { { "location", padding = 0 } },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
