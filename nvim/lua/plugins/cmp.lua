return {
  -- Auto-completion plugin
  -- https://github.com/hrsh7th/nvim-cmp
  "hrsh7th/nvim-cmp",
  dependencies = {
    -- nvim-cmp source for buffer words
    -- https://github.com/hrsh7th/cmp-buffer
    "hrsh7th/cmp-buffer",
    -- nvim-cmp source for path
    -- https://github.com/hrsh7th/cmp-path
    "hrsh7th/cmp-path",
    -- nvim-cmp source for vim's command line
    -- https://github.com/hrsh7th/cmp-cmdline
    "hrsh7th/cmp-cmdline",
    -- nvim-cmp source for Neovim built-in LSP client
    -- https://github.com/hrsh7th/cmp-nvim-lsp
    "hrsh7th/cmp-nvim-lsp",
    -- nvim-cmp source for Neovim Lua
    -- https://github.com/hrsh7th/cmp-nvim-lua
    "hrsh7th/cmp-nvim-lua",
  },
  config = function()
    local cmp = require("cmp")

    local kind_icons = {
      Text = "󰉿",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰆧",
      Class = "󰌗",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰇽",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰊄",
      Copilot = "",
    }

    local has_words_before = function()
      if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
        return false
      end
      local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
        and vim.api
            .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
            :match("^%s*$")
          == nil
    end

    cmp.setup({
      performance = { max_view_entries = 10 },
      preselect = cmp.PreselectMode.None,
      completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,popup,noselect,fuzzy",
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
          -- Configuration to use with copilot.
          if cmp.visible() and has_words_before() then
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          else
            fallback()
          end
        end),
        ["<CR>"] = cmp.mapping({
          -- If nothing is selected (including pre-selections) add a newline as usual.
          -- If something has explicitly been selected by the user, select it.
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = false,
              })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        }),
      }),
      sources = {
        { name = "nvim_lsp", group_index = 1, priority = 2 },
        { name = "nvim_lua", group_index = 1, priority = 2 },
        { name = "buffer", group_index = 1, priority = 2 },
        { name = "path", group_index = 1, priority = 2 },
        { name = "cmdline", group_index = 1, priority = 2 },
      },
      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(_, vim_item)
          if vim_item.kind ~= nil then
            vim_item.kind = (kind_icons[vim_item.kind] or "")
              .. " ["
              .. vim_item.kind
              .. "]"
          end
          return vim_item
        end,
      },
    })

    -- Disable cmp in markdown files' insert mode
    cmp.setup.filetype({ "markdown" }, {
      window = {
        documentation = cmp.config.disable,
      },
    })
  end,
}
