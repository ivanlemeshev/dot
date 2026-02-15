return {
  {
    -- Auto pairs for brackets, quotes, etc.
    -- https://github.com/echasnovski/mini.pairs
    "echasnovski/mini.pairs",
    commit = "4089aa6ea6423e02e1a8326a7a7a00159f6f5e04",
    event = "InsertEnter",
    opts = {},
  },
  {
    -- Visualize and operate on indent scope
    -- https://github.com/echasnovski/mini.indentscope
    "echasnovski/mini.indentscope",
    commit = "0308f949f31769e509696af5d5f91cebb2159c69",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.indentscope").setup({
        symbol = "▏",
        options = { try_as_border = true },
        draw = { animation = require("mini.indentscope").gen_animation.none() },
      })
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "dashboard",
          "lazy",
          "mason",
          "neo-tree",
          "terminal",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    -- Move lines and selections with Alt+hjkl
    -- https://github.com/echasnovski/mini.move
    "echasnovski/mini.move",
    commit = "4d214202d71e0a4066b6288176bbe88f268f9777",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  {
    -- Toggle between single-line and multi-line statements
    -- https://github.com/echasnovski/mini.splitjoin
    "echasnovski/mini.splitjoin",
    commit = "9fcd8856efb95a505090c3225726466494076127",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("mini.splitjoin").setup({
        mappings = { toggle = "gS" },
      })
      vim.keymap.set("n", "gS", function()
        require("mini.splitjoin").toggle()
      end, { desc = "Split/join" })
    end,
  },
  {
    -- Highlight patterns in text (hex colors, TODO, FIXME, etc.)
    -- https://github.com/echasnovski/mini.hipatterns
    "echasnovski/mini.hipatterns",
    commit = "add8d8abad602787377ec5d81f6b248605828e0f",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local hipatterns = require("mini.hipatterns")
      hipatterns.setup({
        highlighters = {
          fixme = {
            pattern = "%f[%w]()FIXME()%f[%W]",
            group = "MiniHipatternsFixme",
          },
          hack = {
            pattern = "%f[%w]()HACK()%f[%W]",
            group = "MiniHipatternsHack",
          },
          todo = {
            pattern = "%f[%w]()TODO()%f[%W]",
            group = "MiniHipatternsTodo",
          },
          note = {
            pattern = "%f[%w]()NOTE()%f[%W]",
            group = "MiniHipatternsNote",
          },
          warning = {
            pattern = "%f[%w]()WARNING()%f[%W]",
            group = "MiniHipatternsFixme",
          },
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      })
    end,
  },
}
