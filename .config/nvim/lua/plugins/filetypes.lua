vim.pack.add({
  {
    src = "https://github.com/hat0uma/csvview.nvim",
    name = "csvview.nvim",
    version = "v1.3.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local filetypes_group = vim.api.nvim_create_augroup("pack-filetypes", { clear = true })

local csvview_loaded = false

-- Load csvview.nvim when CSV file is opened
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = filetypes_group,
  pattern = "*.csv",
  callback = function()
    if not csvview_loaded then
      vim.cmd.packadd("csvview.nvim")

      require("csvview").setup({
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
          -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab>.
          jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
          jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
          -- Enter keymaps disabled to avoid conflicts with NvimTree
          -- Use j/k or arrow keys for vertical navigation instead
        },
      })

      -- Disable in insert mode, re-enable when leaving insert mode
      local csv_group = vim.api.nvim_create_augroup("CsvViewInsertMode", { clear = true })

      vim.api.nvim_create_autocmd("InsertEnter", {
        group = csv_group,
        pattern = "*.csv",
        callback = function()
          if vim.bo.filetype == "csv" then
            vim.cmd("CsvViewDisable")
          end
        end,
      })

      vim.api.nvim_create_autocmd("InsertLeave", {
        group = csv_group,
        pattern = "*.csv",
        callback = function()
          if vim.bo.filetype == "csv" then
            vim.cmd("CsvViewEnable")
          end
        end,
      })

      csvview_loaded = true
    end
  end,
})
