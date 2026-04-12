vim.pack.add({
  {
    src = "https://github.com/hrsh7th/nvim-cmp",
    name = "nvim-cmp",
    version = "v0.0.2",
  },
  {
    src = "https://github.com/hrsh7th/cmp-buffer",
    name = "cmp-buffer",
    version = "main",
  },
  {
    src = "https://github.com/hrsh7th/cmp-path",
    name = "cmp-path",
    version = "main",
  },
  {
    src = "https://github.com/hrsh7th/cmp-cmdline",
    name = "cmp-cmdline",
    version = "main",
  },
  {
    src = "https://github.com/hrsh7th/cmp-nvim-lsp",
    name = "cmp-nvim-lsp",
    version = "main",
  },
  {
    src = "https://github.com/hrsh7th/cmp-nvim-lua",
    name = "cmp-nvim-lua",
    version = "main",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local cmp_group = vim.api.nvim_create_augroup("pack-cmp", { clear = true })

-- Load on InsertEnter or CmdlineEnter
vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  group = cmp_group,
  once = true,
  callback = function()
    vim.cmd.packadd("nvim-cmp")
    vim.cmd.packadd("cmp-buffer")
    vim.cmd.packadd("cmp-path")
    vim.cmd.packadd("cmp-cmdline")
    vim.cmd.packadd("cmp-nvim-lsp")
    vim.cmd.packadd("cmp-nvim-lua")

    local cmp = require("cmp")

    local kind_icons = {
      Text = "󰉿",
      Method = "m",
      Function = "󰊕",
      Constructor = "",
      Field = "",
      Variable = "󰆧",
      Class = "󰌗",
      Interface = "",
      Module = "",
      Property = "",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰇽",
      Struct = "",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰊄",
      Copilot = "",
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
      window = {
        completion = {
          border = "single",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
        documentation = {
          border = "single",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
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

    -- Command line completion (only on Tab, never auto-triggers)
    cmp.setup.cmdline(":", {
      completion = { autocomplete = false },
      mapping = cmp.mapping.preset.cmdline(),
      formatting = { fields = { "abbr" } },
      sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline" } }
      ),
      window = {
        completion = {
          border = "single",
          winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
        },
      },
    })
  end,
})
