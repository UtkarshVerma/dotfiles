---@alias util.ui.border.type "thin"|"thick"|"empty"

---@class util.ui.border.chars
---@field top? string
---@field right? string
---@field bottom? string
---@field left? string
---@field top_left? string
---@field top_right? string
---@field bottom_right? string
---@field bottom_left? string

---@class util.ui
local M = {}

-- Get the foreground color for highlight {name}.
---@param name string
---@return Highlight?
---@nodiscard
function M.fg(name)
  ---@diagnostic disable-next-line: undefined-field
  local hl = vim.api.nvim_get_hl(0, { name = name }) --[[@as Highlight]]
  local fg = hl.fg

  return fg and { fg = string.format("#%06x", fg) }
end

-- Get borderchars of type {type} in specified {order}.
---@param type? util.ui.border.type
---@param order? string
---@param overrides? util.ui.border.chars
---@return util.ui.border.chars
---@nodiscard
function M.borderchars(type, order, overrides)
  order = order or "t-r-b-l-tl-tr-br-bl"
  type = type or "empty"
  overrides = overrides or {}
  local border_icons = vim.tbl_deep_extend("force", require("config").icons.borders[type], overrides)
  local position_mappings = {
    t = "top",
    r = "right",
    b = "bottom",
    l = "left",
    tl = "top_left",
    tr = "top_right",
    br = "bottom_right",
    bl = "bottom_left",
  }

  local borderchars = {}
  for position in order:gmatch("([^-]+)") do
    position = position_mappings[position]
    borderchars[#borderchars + 1] = border_icons[position]
  end

  return borderchars
end

return M
