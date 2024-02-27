---@class plugins.mini.statusline.config
---@field content? table<"active"|"inactive", fun():string>

local config = require("config")
local util = require("util")

-- Display current buffer's file path relative to project directory.
---@return string
---@nodiscard
local function file_path()
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

  local path_sep = util.fs.path_sep
  local parts = vim.split(path, path_sep)
  local max_part_count = 6
  if #parts > max_part_count then
    parts = { parts[1], "…", unpack(parts, #parts - (max_part_count - 1) + 1, #parts) }
  end

  return table.concat(parts, path_sep) .. "%m%r"
end

-- Display the filetype of current buffer.
---@return string
local function filetype()
  local ft = vim.bo.filetype

  -- Don't show anything if can't detect file type or not inside a "normal buffer".
  if (ft == "") or vim.bo.buftype ~= "" then
    return ""
  end

  local icon = require("nvim-web-devicons").get_icon_by_filetype(vim.bo.filetype)
  icon = icon and icon .. " " or ""
  return string.format("%s%s", icon, ft)
end

-- Display current buffer's root directory.
---@return string
local function root_dir()
  return config.icons.misc.RootDir .. " " .. vim.fs.basename(util.root.dir())
end

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    dependencies = {
      "gitsigns.nvim",
      "nvim-web-devicons",
    },
    ---@type plugins.mini.statusline.config
    opts = {
      content = {
        active = function()
          local msl = require("mini.statusline")

          local mode, mode_hl = msl.section_mode({ trunc_width = 120 })
          local git = msl.section_git({ trunc_width = 75 })
          local diagnostics = msl.section_diagnostics({ trunc_width = 75 })

          return msl.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
            "%<", -- Mark general truncate point
            { hl = "Special", strings = { root_dir() } },
            { hl = "MiniStatuslineFilename", strings = { file_path() } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineFileinfo", strings = { filetype() } },
            { hl = mode_hl, strings = { "%l│%v" } },
          })
        end,
      },
    },
  },
}
