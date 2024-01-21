local icons = require("config").icons
local util = require("util")

---@alias plugins.lualine.component util.lualine.component|string

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- TODO: Optional deps
    -- noice, neo-tree, dap?
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            "dashboard",
          },
        },
      },

      ---@type table<string, plugins.lualine.component>
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { util.lualine.root_dir, icon = icons.misc.RootDir, color = util.ui.fg("Special") },
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
          { util.lualine.file_dir, separator = "", padding = 0 },
          {
            util.lualine.file_name,
            padding = { left = 0 },
            -- stylua: ignore
            color = function(_) return vim.bo.modified and util.ui.fg("Constant") or nil end,
          },
        },
        lualine_x = {
          {
            "diff",
            ---@type {added: string, modified: string, removed: string}
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            ---@return {added: integer, modified: integer, removed: integer}?
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
          { util.lualine.clock, icon = icons.misc.clock },
        },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },
}
