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
      -- stylua: ignore
      { "n", "<s-h>", function() require("arrow.persist").previous() end, desc = "Previous buffer"},
      -- stylua: ignore
      { "n", "<s-l>", function() require("arrow.persist").next() end, desc = "Next buffer"},
    },
    ---@type plugins.arrow.config
    opts = {
      leader_key = ";",
      window = {
        border = "none",
      },
      -- TODO: Add this to type
      mappings = {
        prev_item = ";",
      },
    },
  },
}
