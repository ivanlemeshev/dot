return {
  "neovim/nvim-lspconfig",
  event = "BufRead",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    -- This function gets run when an LSP attaches to a particular buffer.
    -- Every time a new file is opened that is associated with the LSP this
    -- function will be executed to configure the current buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local builtin = require("telescope.builtin")
        local map = vim.keymap.set

        map("n", "gd", builtin.lsp_definitions, { desc = "LSP: go to definition" })
        map("n", "gr", builtin.lsp_references, { desc = "LSP: find references" })
        map("n", "gI", builtin.lsp_implementations, { desc = "LSP: go to implementation" })
        map("n", "<leader>D", builtin.lsp_type_definitions, { desc = "LSP: type definition" })
        map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: rename" })
        map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: code action" })
        map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: goto declaration" })

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

          -- Highlight references of the word under the cursor when it rests
          -- there for a while. See `:help CursorHold`.
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          -- When the cursor is moved, the highlights will be cleared.
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          map("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, { desc = "LSP: Toggle inlay hints" })
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what
    -- features they support. By default, Neovim doesn't support everything
    -- that is in the LSP specification. When you add nvim-cmp, luasnip, etc.
    -- Neovim now has more capabilities. So, we create new capabilities with
    -- nvim-cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    require("mason").setup()

    local ensure_installed = {
      "ansiblels", -- ansible
      "bashls", -- bash
      "dockerls", -- docker
      "gopls", -- go
      "jsonls", -- json
      "harper_ls", -- markdown
      "lua_ls", -- lua
      "powershell_es", -- powershell
      "pbls", -- protobuf
      "pyright", -- python
      "terraformls", -- terraform
      "yamlls", -- yaml
      "zls", -- zig
    }

    require("mason-tool-installer").setup({
      ensure_installed = ensure_installed,
    })

    local servers = {
      ansiblels = {},
      bashls = {},
      dockerls = {},
      gopls = {},
      jsonls = {},
      harper_ls = {},
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            format = {
              enable = true,
            },
          },
        },
      },
      powershell_es = {},
      pbls = {},
      pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      },
      terraformls = {},
      yamlls = {},
      zls = {},
    }

    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          require("lspconfig")[server_name].setup(server)
        end,
      },
    })
  end,
}
