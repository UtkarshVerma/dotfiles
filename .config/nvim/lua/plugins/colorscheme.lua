---@class plugins.catppuccin.config: CatppuccinOptions

---@type LazyPluginSpec[]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    version = false, -- NOTE: v1.9.0 lacks Snacks and blink.cmp.
    priority = 1000,
    ---@type plugins.catppuccin.config
    opts = {
      -- color_overrides = {
      --   mocha = require("util").colors,
      -- },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
