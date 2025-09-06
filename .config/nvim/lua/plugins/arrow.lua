---@alias plugins.arrow.mapping_key
---| "edit"
---| "delete_mode"
---| "clear_all_items"
---| "toggle"
---| "open_vertical"
---| "open_horizontal"
---| "quit"
---| "remove"
---| "next_item"
---| "prev_item"

---@class plugins.arrow.config
---@field leader_key? string
---@field hide_handbook? boolean
---@field window? {border?: string}
---@field mappings? table<plugins.arrow.mapping_key,string>

---@type LazyPluginSpec[]
return {
  {
    "otavioschwanck/arrow.nvim",
    keys = {
      { "ga", desc = "Arrow" },
    },
    ---@type plugins.arrow.config
    opts = {
      leader_key = ";",
      window = {
        border = "none",
      },
      mappings = {
        prev_item = ";",
      },
    },
  },
}
