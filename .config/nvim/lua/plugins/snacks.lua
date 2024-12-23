---@module "snacks"
---@class plugins.snacks.config: snacks.Config

---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        snacks = true,
      },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- stylua: ignore start
      { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
      -- stylua: ignore end
    },
    opts = function(_, _)
      ---@type plugins.snacks.config
      return {
        bigfile = { enabled = true },
        lazygit = { enabled = true },
        toggle = { enabled = true, which_key = false },
      }
    end,
    config = function(_, opts)
      require("snacks").setup(opts)

      Snacks.toggle.option("spell"):map("<leader>ts", { desc = "Spelling" })
      Snacks.toggle.option("wrap"):map("<leader>tw", { desc = "Word wrap" })
      Snacks.toggle.diagnostics():map("<leader>td", { desc = "Diagnostics" })
      Snacks.toggle.inlay_hints():map("<leader>ti", { desc = "Inlay hints" })
    end,
  },
}
