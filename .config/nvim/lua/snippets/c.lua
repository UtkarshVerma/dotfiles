---@module "types.luasnip"
---@module "luasnip._types"

---@return boolean
local function is_file_empty(_)
  -- All lines other than the current one should be empty.
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local cursor_line = unpack(vim.api.nvim_win_get_cursor(0))
  lines[cursor_line] = ""
  for _, line in ipairs(lines) do
    if line ~= "" then
      return false
    end
  end

  return true
end

---@return string
local function get_macro_name()
  local filename = vim.fn.expand("%:t")
  local macro_name, _ = filename:upper():gsub("%.", "_")

  return macro_name
end

return {
  s(
    {
      trig = "ig",
      name = "Include guard",
      desc = "Add an include guard.",
      show_condition = is_file_empty,
    },
    fmta(
      [[
#ifndef <>
#define <>

<>

#endif  // <>
]],
      {
        i(1, get_macro_name()),
        rep(1),
        i(0),
        rep(1),
      }
    )
  ),
}
