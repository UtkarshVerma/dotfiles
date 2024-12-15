---@module "neogit"
---@class plugins.neogit.config: NeogitConfig

---@type LazyPluginSpec[]
return {
  {
    "NeogitOrg/neogit",
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    dependencies = {
      "plenary.nvim",
      "sindrets/diffview.nvim",
      "telescope.nvim",
    },
    ---@type plugins.neogit.config
    opts = {},
  },
}
