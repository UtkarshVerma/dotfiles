---@type LazyPluginSpec[]
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    dependencies = {
      "plenary.nvim",
      "sindrets/diffview.nvim",
      "telescope.nvim",
    },
    opts = {},
  },
}
