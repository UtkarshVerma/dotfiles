---@alias plugins.lualine.section "lualine_a"|"lualine_b"|"lualine_c"|"lualine_x"|"lualine_y"|"lualine_z"

---@class plugins.lualine.component
---@field [1] string|fun():string
---@field icons_enabled? boolean
---@field icon? string|{str: string, color?: Highlight}
---@field separator? string|{left?: string, right?: string}
---@field cond? fun():boolean
---@field draw_empty? boolean
---@field color? string|Highlight|fun(section:string):Highlight?
---@field type? string
---@field padding? integer|{left?: integer, right?: integer}
---@field fmt? fun(str:string, context:{options: plugins.lualine.component}):string
---@field on_click? fun(click_count:integer, button:"l"|"r"|"m", modifiers: "s"|"c"|"a"|"m")

---@class plugins.lualine.components.diagnostics: plugins.lualine.component
---@field [1] "diagnostics"
---@field symbols? {error?: string, warn?: string , info?: string, hint?: string}

---@class plugins.lualine.components.diff: plugins.lualine.component
---@field [1] "diff"
---@field symbols? {added: string, modified: string, removed: string}
---@field source? fun():{added: integer, modified: integer, removed: integer}

---@class plugins.lualine.config
---@field options {globalstatus?: boolean, disabled_filetypes?: {statusline?: string[]}}
---@field sections table<plugins.lualine.section, (plugins.lualine.component|string)[]>
---@field extensions string[]

local icons = require("config").icons
local util = require("util")

-- Display the directory path for the current buffer.
---@return string
local function dir()
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

---@type LazyPluginSpec[]
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    ---@type plugins.lualine.config
    opts = {
      options = {
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            "dashboard",
          },
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          -- Display current project's root directory.
          {
            function()
              return vim.fs.basename(util.root.dir())
            end,
            icon = icons.misc.RootDir,
            color = util.ui.fg("Special"),
          },
          ---@type plugins.lualine.components.diagnostics
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "" },

          -- Display the file path for current buffer and highlight the basename when unsaved changes exist.
          { dir, separator = "", padding = 0 },
          {
            -- stylua: ignore
            function() return vim.fn.expand("%:t") end,
            padding = { left = 0 },
            -- stylua: ignore
            color = function(_) return vim.bo.modified and util.ui.fg("Constant") or nil end,
          },
        },
        lualine_x = {
          ---@type plugins.lualine.components.diff
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b["gitsigns_status_dict"] --[[@as plugins.gitsigns.status_dict?]]

              if gitsigns ~= nil then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          -- stylua: ignore
          { function() return os.date("%R") end, icon = icons.misc.clock },
        },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },
}
