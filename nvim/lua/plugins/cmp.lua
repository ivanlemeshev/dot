return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
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
    }

    cmp.setup({
      performance = {
        max_view_entries = 10,
      },
      preselect = cmp.PreselectMode.Item,
      completion = {
        keyword_length = 1,
        completeopt = "menu,menuone,popup,noinsert,fuzzy",
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
      },
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = kind_icons[vim_item.kind]
          vim_item.menu = ({
            buffer = "[Buffer]",
            path = "[Path]",
            cmdline = "[Cmdline]",
            nvim_lua = "[Lua]",
            nvim_lsp = "[LSP]",
          })[entry.source.name]
          return vim_item
        end,
      },
    })
  end,
}
