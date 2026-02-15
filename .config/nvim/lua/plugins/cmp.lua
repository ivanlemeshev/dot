return {
  -- Auto-completion plugin
  -- https://github.com/hrsh7th/nvim-cmp
  "hrsh7th/nvim-cmp",
  commit = "da88697d7f45d16852c6b2769dc52387d1ddc45f",
  dependencies = {
    -- nvim-cmp source for buffer words
    -- https://github.com/hrsh7th/cmp-buffer
    {
      "hrsh7th/cmp-buffer",
      commit = "b74fab3656eea9de20a9b8116afa3cfc4ec09657",
    },
    -- nvim-cmp source for path
    -- https://github.com/hrsh7th/cmp-path
    { "hrsh7th/cmp-path", commit = "c642487086dbd9a93160e1679a1327be111cbc25" },
    -- nvim-cmp source for vim's command line
    -- https://github.com/hrsh7th/cmp-cmdline
    {
      "hrsh7th/cmp-cmdline",
      commit = "d126061b624e0af6c3a556428712dd4d4194ec6d",
    },
    -- nvim-cmp source for Neovim built-in LSP client
    -- https://github.com/hrsh7th/cmp-nvim-lsp
    {
      "hrsh7th/cmp-nvim-lsp",
      commit = "cbc7b02bb99fae35cb42f514762b89b5126651ef",
    },
    -- nvim-cmp source for Neovim Lua
    -- https://github.com/hrsh7th/cmp-nvim-lua
    {
      "hrsh7th/cmp-nvim-lua",
      commit = "e3a22cb071eb9d6508a156306b102c45cd2d573d",
    },
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
      -- This ensures compatibility across all Lua versions
      local unpack = unpack or table.unpack

      if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
        return false
      end

      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
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
        { name = "emoji", group_index = 1, priority = 2 },
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
