---@alias util.lualine.config.section "lualine_a"|"lualine_b"|"lualine_c"|"lualine_x"|"lualine_y"|"lualine_z"

---@class util.lualine.config.options
---@field globalstatus? boolean

---@class util.lualine.config
---@field options table
---@field sections table<util.lualine.config.section, (util.lualine.component|string)[]>
---@field extensions string[]

---@class util.lualine.component
---@field [integer] string|fun():string
---@field icons_enabled? boolean
---@field icon? string|{str: string, color?: Highlight}
---@field separator? string|{left?: string, right?: string}
---@field cond? fun():boolean
---@field draw_empty? boolean
---@field color? string|Highlight|fun(section:string):Highlight?
---@field type? string
---@field padding? integer|{left?: integer, right?: integer}
---@field fmt? fun(str:string, context:{options: util.lualine.component}):string
---@field on_click? fun(click_count:integer, button:"l"|"r"|"m", modifiers: "s"|"c"|"a"|"m")

---@class util.lualine
local M = {}

-- Display the directory path for the current buffer.
---@return string
function M.get_dir()
  local util = require("util")

  local path = vim.fn.expand("%:p")
  if path == "" then
    return ""
  end

  local cwd = util.fs.cwd() or ""

  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  else
    local root = util.root.dir()
    path = path:sub(#root + 2)
  end

  local path_sep = package.config:sub(1, 1)
  local parts = vim.split(path, path_sep)
  if #parts > 3 then
    parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
  end

  -- Remove filename and add a trailing separator.
  parts[#parts] = ""

  return table.concat(parts, path_sep)
end

return M
