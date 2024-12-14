---@module "oil"
---@class plugins.oil.config: oil.SetupOpts

---@type LazyPluginSpec[]
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-web-devicons" },
    cmd = { "Oil" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    ---@type plugins.oil.config
    opts = {},
  },
}
