return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {},
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "static",
        timeout = 5000,
        vim.cmd([[
          highlight NotifyERRORBorder guifg=#F38BA8
          highlight NotifyWARNBorder guifg=#FAB387
          highlight NotifyINFOBorder guifg=#A6E3A1
          highlight NotifyDEBUGBorder guifg=#9399B2
          highlight NotifyTRACEBorder guifg=#CBA6F7
          highlight NotifyERRORIcon guifg=#F38BA8
          highlight NotifyWARNIcon guifg=#FAB387
          highlight NotifyINFOIcon guifg=#A6E3A1
          highlight NotifyDEBUGIcon guifg=#9399B2
          highlight NotifyTRACEIcon guifg=#CBA6F7
          highlight NotifyERRORTitle  guifg=#F38BA8
          highlight NotifyWARNTitle guifg=#FAB387
          highlight NotifyINFOTitle guifg=#A6E3A1
          highlight NotifyDEBUGTitle  guifg=#9399B2
          highlight NotifyTRACETitle  guifg=#CBA6F7
        ]]),
      })
    end,
  },
}
