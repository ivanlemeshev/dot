return {
  "nvim-lualine/lualine.nvim",
  commit = "47f91c416daef12db467145e16bed5bbfe00add8",
  event = "VeryLazy",
  dependencies = {
    {
      "nvim-tree/nvim-web-devicons",
      commit = "746ffbb17975ebd6c40142362eee1b0249969c5c",
    },
    {
      "AndreM222/copilot-lualine",
      commit = "222e90bd8dcdf16ca1efc4e784416afb5f011c31",
    },
  },
  config = function()
    local separator = "%#LualineSeparator#│"
    local with_separator = function(str)
      if str == nil or str == "" then
        return ""
      end
      return str .. " " .. separator
    end

    local separator_padding = { left = 1, right = 0 }

    local mode = {
      "mode",
      fmt = function(str)
        return " " .. str
      end,
    }

    local filename = {
      "filename",
      file_status = true,
      path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
    }

    local branch = {
      "branch",
      icon = "",
      fmt = with_separator,
      padding = separator_padding,
    }

    local copilot = {
      "copilot",
      fmt = with_separator,
      padding = separator_padding,
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
      symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
      colored = false,
      update_in_insert = true,
      always_visible = true,
      fmt = with_separator,
      padding = separator_padding,
    }

    local diff = {
      "diff",
      colored = false,
      sections = { "added", "modified", "removed" },
      symbols = { added = " ", modified = " ", removed = " " },
      fmt = with_separator,
      padding = separator_padding,
    }

    require("lualine").setup({
      options = {
        theme = require("lem.colorscheme").lualine_theme,
        icons_enabled = true,
        --          
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        always_divide_middle = true,
        disabled_filetypes = {
          "NvimTree",
          "trouble",
        },
      },
      -- +-------------------------------------------------+
      -- | A | B | C                             X | Y | Z |
      -- +-------------------------------------------------+
      sections = {
        lualine_a = { mode },
        lualine_b = { branch, diff, filename },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          copilot,
          diagnostics,
          { "encoding", fmt = with_separator, padding = separator_padding },
          { "filetype", fmt = with_separator, padding = separator_padding },
          "location",
        },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
