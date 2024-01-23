local util = require("util")

return {
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        border = util.ui.borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
        win_options = { winblend = 0 },
      },
    },
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
}
