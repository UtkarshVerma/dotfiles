---@alias plugins.mini.surround.mapping "add"|"delete"|"find"|"find_left"|"highlight"|"replace"|"update_n_lines"|"suffix_last"|"suffix_next"

---@class plugins.mini.surround.config
---@field n_lines? integer
---@field mappings? table<plugins.mini.surround.mapping, string>

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.surround",
    event = "LazyFile",
    ---@type plugins.mini.surround.config
    opts = {},
  },
}
