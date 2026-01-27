return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    "hrsh7th/cmp-nvim-lsp",
    "lukas-reineke/lsp-format.nvim",
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

        map(
          "n",
          "gd",
          builtin.lsp_definitions,
          { desc = "LSP: go to definition", silent = true }
        )
        map(
          "n",
          "gr",
          builtin.lsp_references,
          { desc = "LSP: find all references", silent = true }
        )
        map(
          "n",
          "gI",
          builtin.lsp_implementations,
          { desc = "LSP: go to implementation", silent = true }
        )
        map(
          "n",
          "<leader>D",
          builtin.lsp_type_definitions,
          { desc = "LSP: go type definition", silent = true }
        )
        map(
          "n",
          "gD",
          vim.lsp.buf.declaration,
          { desc = "LSP: goto declaration", silent = true }
        )
        map(
          "n",
          "K",
          vim.lsp.buf.hover,
          { desc = "LSP: hover documentation", silent = true }
        )
        map(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          { desc = "LSP: rename", silent = true }
        )
        map(
          "n",
          "<leader>ca",
          vim.lsp.buf.code_action,
          { desc = "LSP: code action", silent = true }
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

        if
          client
          and client.supports_method(
            vim.lsp.protocol.Methods.textDocument_inlayHint
          )
        then
          map("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
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

    require("mason").setup({
      pip = {
        install_args = {
          "--break-system-packages",
        },
      },
    })

    require("lsp-format").setup({})

    local exclude_automatic_enable = {
      "clangd",
      "lua_ls",
      "pyright",
      "buf_ls",
      "yamlls",
    }

    require("mason-lspconfig").setup({
      automatic_enable = {
        exclude = exclude_automatic_enable,
      },
    })

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

    for server, config in pairs(lsp_config) do
      local existing_config = vim.lsp.config[server] or {}
      local merged_config =
        vim.tbl_deep_extend("force", existing_config, config)
      vim.lsp.config(server, merged_config)
      vim.lsp.enable(server)
    end
  end,
}
