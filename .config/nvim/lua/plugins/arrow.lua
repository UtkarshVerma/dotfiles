---@class plugins.arrow.config
---@field leader_key? string
---@field hide_handbook? boolean
---@field window? {border?: string}

---@type LazyPluginSpec[]
return {
  {
    "otavioschwanck/arrow.nvim",
    keys = {
      { "ga", desc = "Arrow" },
    },
    ---@type plugins.arrow.config
    opts = {
      leader_key = "ga",
      window = {
        border = "none",
      },
      -- TODO: Add this to type
      mappings = {
        prev_item = "k",
        next_item = "j",
      },
    },
  },
}
