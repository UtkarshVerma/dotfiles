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
      { "<leader>ts", function() Snacks.toggle.option("spell") end, desc = "Spelling" },
      { "<leader>tw", function() Snacks.toggle.option("wrap") end, desc = "Word wrap" },
      { "<leader>td", function() Snacks.toggle.diagnostics() end, desc = "Diagnostics" },
      { "<leader>ti", function() Snacks.toggle.inlay_hints() end, desc = "Inlay hints" },
      -- stylua: ignore end
    },
    ---@type plugins.snacks.config
    opts = {
      bigfile = { enabled = true },
      lazygit = { enabled = true },
      toggle = { enabled = true, which_key = false },
    },
  },
}
