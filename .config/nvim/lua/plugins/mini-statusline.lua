---@class plugins.mini.statusline.config
---@field content? table<"active"|"inactive", fun():string>
---@field set_vim_settings? boolean

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
  path = path:sub(#cwd + 2)

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
---@return string?
local function root_dir()
  local cwd = util.fs.cwd()
  if cwd ~= nil then
    return config.icons.misc.RootDir .. " " .. vim.fs.basename(cwd)
  end

  return nil
end

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.statusline",
    lazy = false, -- Don't lazy load as it flickers the status bar.
    dependencies = { "nvim-web-devicons" }, -- Avoid loading gitsigns early.
    ---@type plugins.mini.statusline.config
    opts = {
      content = {
        active = function()
          local msl = require("mini.statusline")

          local mode, mode_hl = msl.section_mode({ trunc_width = 120 })
          local git = msl.section_git({ trunc_width = 75 })
          local diagnostics = msl.section_diagnostics({ trunc_width = 75 })

          local arrow_nvim = util.plugin.exists("arrow.nvim")
            and {
              hl = "Special",
              strings = { require("arrow.statusline").text_for_statusline_with_icons() },
            }

          return msl.combine_groups({
            { hl = mode_hl, strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics } },
            "%<", -- Mark general truncate point
            { hl = "Special", strings = { root_dir() } },
            { hl = "MiniStatuslineFilename", strings = { file_path() } },
            "%=", -- End left alignment
            arrow_nvim,
            { hl = "MiniStatuslineFileinfo", strings = { filetype() } },
            { hl = mode_hl, strings = { "%l│%v" } },
          })
        end,
      },
    },
  },
}
