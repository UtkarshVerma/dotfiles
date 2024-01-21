---@class util.lualine
local M = {}

---@class util.lualine.component
---@field icons_enabled? boolean
---@field icon? string|{str: string, color?: Highlight}
---@field separator? string|{left?: string, right?: string}
---@field cond? fun():boolean
---@field draw_empty? boolean
---@field color? string|Highlight|fun(section:string):Highlight
---@field type? string
---@field padding? integer|{left?: integer, right?: integer}
---@field fmt? fun(str:string, context:{options: util.lualine.component}):string
---@field on_click? fun(click_count:integer, button:"l"|"r"|"m", modifiers: "s"|"c"|"a"|"m")

---@class util.lualine.component.file_path: util.lualine.component
---@field modified_hl string

-- Display the basename for the current buffer.
---@return string
function M.file_name()
  return vim.fn.expand("%:t")
end

-- Display the directory path for the current buffer.
---@return string
function M.file_dir()
  local util = require("util")

  local path = vim.fn.expand("%:p")
  if path == "" then
    return ""
  end

  local cwd = util.root.cwd()

  if path:find(cwd, 1, true) == 1 then
    path = path:sub(#cwd + 2)
  else
    local root = util.root.get({ normalize = true })
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

-- Display the basename of current project's root directory.
---@return string
function M.root_dir()
  local util = require("util")
  local root = util.root.get({ normalize = true })

  return vim.fs.basename(root)
end

-- Display the time.
---@return string
function M.clock()
  return tostring(os.date("%R"))
end

return M
