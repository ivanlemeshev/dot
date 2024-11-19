return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "\\",
      ":Neotree reveal<CR>",
      desc = "Go to NeoTree",
      noremap = true,
      silent = true,
    },
    {
      "<leader>e",
      ":Neotree toggle position=left<CR>",
      desc = "Toggle NeoTree",
      noremap = true,
      silent = true,
    },
  },
  init = function()
    -- FIX: use `autocmd` for lazy-loading neo-tree instead of directly
    -- requiring it, because `cwd` is not set up properly.
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        else
          local stats = vim.uv.fs_stat(vim.fn.argv(0))
          if stats and stats.type == "directory" then
            require("neo-tree")
          end
        end
      end,
    })

    local function getTelescopeOpts(state, path)
      return {
        cwd = path,
        search_dirs = { path },
        attach_mappings = function(prompt_bufnr, map)
          local actions = require("telescope.actions")
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local action_state = require("telescope.actions.state")
            local selection = action_state.get_selected_entry()
            local filename = selection.filename
            if filename == nil then
              filename = selection[1]
            end
            -- any way to open the file without triggering auto-close event of neo-tree?
            require("neo-tree.sources.filesystem").navigate(state, state.path, filename)
          end)
          return true
        end,
      }
    end

    require("neo-tree").setup({
      filesystem = {
        window = {
          mappings = {
            ["tg"] = "telescope_grep",
          },
        },
      },
      commands = {
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require("telescope.builtin").live_grep(getTelescopeOpts(state, path))
        end,
      },
    })
  end,
  opts = {
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = {
          ".git",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
      use_libuv_file_watcher = true, -- auto-refresh on file change
    },
  },
}
