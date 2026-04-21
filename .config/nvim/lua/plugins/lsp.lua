local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    name = "nvim-lspconfig",
    version = "v2.8.0",
  },
  {
    src = "https://github.com/lukas-reineke/lsp-format.nvim",
    name = "lsp-format.nvim",
    version = "v2.7.2",
  },
}, {
  load = false,
  confirm = false,
})

local lsp_config = {
  buf_ls = {
    root_dir = function(bufnr, on_dir)
      on_dir(vim.fs.root(bufnr, { "buf.yaml", ".git" }))
    end,
  },
  clangd = {
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  },
  gopls = {
    settings = {
      gopls = {
        buildFlags = { "-tags=integration" },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = {
          globals = {
            "after_each",
            "assert",
            "before_each",
            "describe",
            "it",
            "stub",
            "vim",
          },
        },
        workspace = {
          checkThirdParty = false,
          library = {
            vim.env.VIMRUNTIME,
            "${3rd}/busted/library",
            "tests/vendor/plenary.nvim/lua",
          },
        },
        telemetry = { enable = false },
      },
    },
  },
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          ignore = { "*" },
        },
      },
    },
  },
  yamlls = {
    settings = {
      yaml = {
        format = {
          enable = false,
        },
      },
    },
  },
}

local function setup_lsp_keymaps(event)
  if vim.b[event.buf].large_file then
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client then
      vim.schedule(function()
        pcall(vim.lsp.buf_detach_client, event.buf, client.id)
      end)
    end
    return
  end

  local buf = event.buf
  local fzf_maps = {
    { "gd", "lsp_definitions", "LSP: go to definition" },
    { "grr", "lsp_references", "LSP: find all references" },
    { "gri", "lsp_implementations", "LSP: go to implementation" },
    { "gtd", "lsp_typedefs", "LSP: go type definition" },
    { "gO", "lsp_document_symbols", "LSP: document symbols" },
  }

  for _, item in ipairs(fzf_maps) do
    local lhs, method, desc = item[1], item[2], item[3]
    helpers.nmap(lhs, function()
      require("plugins.search").fzf()[method]()
    end, desc, { buffer = buf })
  end

  local native_maps = {
    { "gD", vim.lsp.buf.declaration, "LSP: goto declaration" },
    { "grn", vim.lsp.buf.rename, "LSP: rename" },
    { "gra", vim.lsp.buf.code_action, "LSP: code action" },
  }

  for _, item in ipairs(native_maps) do
    local lhs, rhs, desc = item[1], item[2], item[3]
    helpers.nmap(lhs, rhs, desc, { buffer = buf })
  end

  helpers.nmap("K", function()
    vim.lsp.buf.hover({ border = "single", focusable = false })
  end, "LSP: hover documentation", { buffer = buf })

  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client.server_capabilities.inlayHintProvider then
    helpers.nmap("<leader>th", function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
        { bufnr = buf }
      )
    end, "LSP: Toggle inlay hints", { buffer = buf })
  end
end

local function setup_document_highlight(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if not client or not client.server_capabilities.documentHighlightProvider then
    return
  end

  local highlight_augroup =
    vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = event.buf,
    group = highlight_augroup,
    callback = vim.lsp.buf.document_highlight,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = event.buf,
    group = highlight_augroup,
    callback = vim.lsp.buf.clear_references,
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
    callback = function(event2)
      vim.lsp.buf.clear_references()
      vim.api.nvim_clear_autocmds({
        group = "lsp-highlight",
        buffer = event2.buf,
      })
    end,
  })
end

local function setup_lsp_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
    callback = function(event)
      setup_lsp_keymaps(event)
      setup_document_highlight(event)
    end,
  })
end

local function apply_lsp_config()
  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  )

  for server, config in pairs(lsp_config) do
    local existing_config = vim.lsp.config[server] or {}
    vim.lsp.config(
      server,
      vim.tbl_deep_extend("force", existing_config, {
        capabilities = capabilities,
      }, config)
    )
  end
end

helpers.load_on("FileType", "pack-lsp", {
  "nvim-lspconfig",
  "lsp-format.nvim",
  "cmp-nvim-lsp",
}, function()
  setup_lsp_attach()
  require("lsp-format").setup({})
  apply_lsp_config()
  require("mason-lspconfig").setup({ automatic_enable = true })
end, {
  pattern = "*",
})
