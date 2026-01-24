return {
  {
    -- Dev helper for Lua development in Neovim
    -- https://github.com/folke/lazydev.nvim
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    -- Hints for key bindings
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    opts = {
      icons = {
        mappings = false,
      },
    },
  },
  {
    -- Highlight TODO, NOTE, FIX, WARNING, HACK, RERF in comments
    -- https://github.com/folke/todo-comments.nvim
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
    },
  },
  {
    -- Show inline diagnostics at the end of the line
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
  {
    "allaman/emoji.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      enable_cmp_integration = true,
    },
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { "#", "//" } },
      view = {
        display_mode = "border",
        min_column_width = 5, -- Make columns more compact (default: 5)
        spacing = 0, -- Reduce spacing between columns (default: 2)
      },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    config = function(_, opts)
      require("csvview").setup(opts)
      -- Disable in insert mode, re-enable when leaving insert mode
      local group =
        vim.api.nvim_create_augroup("CsvViewInsertMode", { clear = true })
      vim.api.nvim_create_autocmd("InsertEnter", {
        group = group,
        pattern = "*.csv",
        callback = function()
          if vim.bo.filetype == "csv" then
            vim.cmd("CsvViewDisable")
          end
        end,
      })
      vim.api.nvim_create_autocmd("InsertLeave", {
        group = group,
        pattern = "*.csv",
        callback = function()
          if vim.bo.filetype == "csv" then
            vim.cmd("CsvViewEnable")
          end
        end,
      })
    end,
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      char = "┆",
      virtcolumn = "81,121",
    },
  },
}
