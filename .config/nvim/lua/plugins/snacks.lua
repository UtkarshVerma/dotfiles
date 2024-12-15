---@module "snacks"
---@class plugins.snacks.config: snacks.Config

---@type LazyPluginSpec[]
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- stylua: ignore start
      { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
      -- stylua: ignore end
    },
    ---@type plugins.snacks.config
    opts = {
      bigfile = { enabled = true },
      lazygit = { enabled = true },
    },
  },
}
