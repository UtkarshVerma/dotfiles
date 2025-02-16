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

---Navigate buffers in `dir`. In case of a trivial bookmark list, fall back to native buffer navigation.
---@param dir "next"|"previous"
local function navigate(dir)
  return function()
    if vim.tbl_count(vim.g.arrow_filenames) <= 1 then
      vim.cmd("b" .. dir)
      return
    end

    local persist = require("arrow.persist")
    persist[dir]()
  end
end

---@type LazyPluginSpec[]
return {
  {
    "otavioschwanck/arrow.nvim",
    keys = {
      { "ga", desc = "Arrow" },
      { "<s-h>", navigate("previous"), desc = "Previous buffer" },
      { "<s-l>", navigate("next"), desc = "Next buffer" },
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
