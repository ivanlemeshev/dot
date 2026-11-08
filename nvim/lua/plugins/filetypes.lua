local helpers = require("config.helpers")

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

local configured = false

local function csvview_command(command)
  pcall(function()
    vim.cmd(command)
  end)
end

local function setup_csvview()
  if configured then
    return
  end

  require("csvview").setup({
    parser = { comments = { "#", "//" } },
    view = {
      display_mode = "border",
      min_column_width = 5,
      spacing = 0,
    },
    keymaps = {
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
    },
  })

  local csv_group = helpers.augroup("CsvViewInsertMode")
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = csv_group,
    pattern = "*.csv",
    callback = function()
      if vim.bo.filetype == "csv" then
        csvview_command("CsvViewDisable")
      end
    end,
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = csv_group,
    pattern = "*.csv",
    callback = function()
      if vim.bo.filetype == "csv" then
        csvview_command("CsvViewEnable")
      end
    end,
  })

  configured = true
end

helpers.load_on(
  { "BufReadPre", "BufNewFile" },
  "pack-filetypes",
  "csvview.nvim",
  function()
    setup_csvview()
    csvview_command("CsvViewEnable")
  end,
  {
    pattern = "*.csv",
    once = false,
  }
)
