---@class plugins.arrow.config.window
---@field width? integer|"auto"
---@field height? integer|"auto"
---@field border? "none"|"single"|"double"|"rounded"|"solid"|"shadow"|string[]|string[][]
---@field row? integer|"auto"
---@field col? integer|"auto"

---@class plugins.arrow.config
---@field leader_key? string
---@field hide_handbook? boolean
---@field window? plugins.arrow.config.window

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
