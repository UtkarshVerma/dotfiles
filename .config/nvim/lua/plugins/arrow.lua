---@class plugins.arrow.config
---@field leader_key? string
---@field hide_handbook? boolean
---@field window? vim.window.opts

---@type LazyPluginSpec[]
return {
  {
    "otavioschwanck/arrow.nvim",
    keys = {
      { ",", desc = "Arrow" },
    },
    ---@type plugins.arrow.config
    opts = {
      leader_key = ",",
      window = {
        border = "none",
      },
    },
  },
}
