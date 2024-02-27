local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        border = util.ui.borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
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
