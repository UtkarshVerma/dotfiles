---@type LazyPluginSpec[]
return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>tz", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    ---@type ZenOptions
    opts = {},
  },
}
