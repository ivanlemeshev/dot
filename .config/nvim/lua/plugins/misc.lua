return {
  {
    -- Hints for key bindings
    -- https://github.com/folke/which-key.nvim
    "folke/which-key.nvim",
    commit = "3aab2147e74890957785941f0c1ad87d0a44c15a",
    opts = {
      icons = {
        mappings = false,
      },
      win = {
        border = "rounded",
      },
    },
  },
  {
    -- Highlight TODO, NOTE, FIX, WARNING, HACK, RERF in comments
    -- https://github.com/folke/todo-comments.nvim
    "folke/todo-comments.nvim",
    commit = "31e3c38ce9b29781e4422fc0322eb0a21f4e8668",
    dependencies = { { "nvim-lua/plenary.nvim", commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" } },
    opts = {
      signs = false,
    },
  },
  {
    -- Show inline diagnostics at the end of the line
    -- https://github.com/rachartier/tiny-inline-diagnostic.nvim
    "rachartier/tiny-inline-diagnostic.nvim",
    commit = "ecce93ff7db4461e942c03e0fcc64bd785df4057",
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
  {
    "allaman/emoji.nvim",
    commit = "643dd52a8f1c40ab4eb93a381352ee3231850bcf",
    dependencies = {
      { "nvim-lua/plenary.nvim", commit = "b9fd5226c2f76c951fc8ed5923d85e4de065e509" },
      { "hrsh7th/nvim-cmp", commit = "da88697d7f45d16852c6b2769dc52387d1ddc45f" },
    },
    opts = {
      enable_cmp_integration = true,
    },
  },
  {
    "hat0uma/csvview.nvim",
    commit = "8d068c526ab5ade68226de036d533298cd93a399",
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
    "Wansmer/treesj",
    commit = "186084dee5e9c8eec40f6e39481c723dd567cb05",
    keys = { "<space>m", "<space>j", "<space>s" },
    dependencies = { { "nvim-treesitter/nvim-treesitter", commit = "42fc28ba918343ebfd5565147a42a26580579482" } },
    config = function()
      require("treesj").setup()
    end,
  },
}
