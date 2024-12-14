---@class plugins.markview.config
---@field filetypes? string[]

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
        "html",
        "latex",
      },
    },
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended since the plugin lazy-loads itself.
    dependencies = {
      "nvim-treesitter",
      "nvim-web-devicons",
    },
    ---@type plugins.markview.config
    opts = {
      filetypes = { "markdown", "Avante" },
    },
  },
}
