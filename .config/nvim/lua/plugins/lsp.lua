return {
  "neovim/nvim-lspconfig",
  commit = "d1597791f8196519439b3a036b59b09023981e1d",
  dependencies = {
    {
      "williamboman/mason.nvim",
      commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65",
    },
    {
      "williamboman/mason-lspconfig.nvim",
      commit = "ae609525ddf01c153c39305730b1791800ffe4fe",
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      commit = "443f1ef8b5e6bf47045cb2217b6f748a223cf7dc",
    },
    {
      "j-hui/fidget.nvim",
      commit = "7fa433a83118a70fe24c1ce88d5f0bd3453c0970",
      opts = {},
    },
    {
      "hrsh7th/cmp-nvim-lsp",
      commit = "cbc7b02bb99fae35cb42f514762b89b5126651ef",
    },
    {
      "lukas-reineke/lsp-format.nvim",
      commit = "42d1d3e407c846d95f84ea3767e72ed6e08f7495",
    },
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
        local buf = event.buf

        map(
          "n",
          "gd",
          builtin.lsp_definitions,
          { desc = "LSP: go to definition", buffer = buf, silent = true }
        )
        map(
          "n",
          "grr",
          builtin.lsp_references,
          { desc = "LSP: find all references", buffer = buf, silent = true }
        )
        map(
          "n",
          "gri",
          builtin.lsp_implementations,
          { desc = "LSP: go to implementation", buffer = buf, silent = true }
        )
        map(
          "n",
          "gtd",
          builtin.lsp_type_definitions,
          { desc = "LSP: go type definition", buffer = buf, silent = true }
        )
        map(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          { desc = "LSP: goto declaration", buffer = buf, silent = true }
        )
        map("n", "K", function()
          vim.lsp.buf.hover({ border = "single" })
        end, { desc = "LSP: hover documentation", buffer = buf, silent = true })
        map(
          "n",
          "grn",
          vim.lsp.buf.rename,
          { desc = "LSP: rename", buffer = buf, silent = true }
        )
        map(
          "n",
          "gra",
          vim.lsp.buf.code_action,
          { desc = "LSP: code action", buffer = buf, silent = true }
        )
        map(
          "n",
          "gO",
          builtin.lsp_document_symbols,
          { desc = "LSP: document symbols", buffer = buf, silent = true }
        )

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if client and client.server_capabilities.documentHighlightProvider then
          local highlight_augroup =
            vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

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
              vim.api.nvim_clear_autocmds({
                group = "lsp-highlight",
                buffer = event2.buf,
              })
            end,
          })
        end

        if client and client.server_capabilities.inlayHintProvider then
          map("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }),
              { bufnr = event.buf }
            )
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
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      require("cmp_nvim_lsp").default_capabilities()
    )

    require("lsp-format").setup({})

    local util = require("lspconfig.util")

    local lsp_config = {
      buf_ls = {
        -- This is the crucial line: it tells buf_ls to look for a
        -- buf.yaml or .git file and use that directory as its root,
        -- which is required to resolve PACKAGE_DIRECTORY_MATCH.
        root_dir = util.root_pattern("buf.yaml", ".git"),
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
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            format = {
              enable = false, -- Disable yamlls formatting in favor of yamlfmt
            },
          },
        },
      },
    }

    -- Apply all custom configs
    for server, config in pairs(lsp_config) do
      local existing_config = vim.lsp.config[server] or {}
      local merged_config =
        vim.tbl_deep_extend("force", existing_config, config)
      vim.lsp.config(server, merged_config)
    end

    -- mason-lspconfig will automatically enable all installed servers
    require("mason-lspconfig").setup({ automatic_enable = true })
  end,
}
