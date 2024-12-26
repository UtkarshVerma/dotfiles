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
      { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Terminal" },
      -- stylua: ignore end
    },
    ---@type plugins.snacks.config
    opts = {
      bigfile = { enabled = true },
      lazygit = { enabled = true },
      toggle = { enabled = true, which_key = false },
      terminal = {
        ---@diagnostic disable-next-line: missing-fields
        win = {
          wo = {
            winbar = "", -- Disable winbar.
          },
        },
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      Snacks.toggle.option("spell"):map("<leader>ts", { desc = "Spelling" })
      Snacks.toggle.option("wrap"):map("<leader>tw", { desc = "Word wrap" })
      Snacks.toggle.diagnostics():map("<leader>td", { desc = "Diagnostics" })
    end,
  },
}
