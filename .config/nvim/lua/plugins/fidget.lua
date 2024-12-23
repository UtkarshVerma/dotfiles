---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        fidget = true,
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
