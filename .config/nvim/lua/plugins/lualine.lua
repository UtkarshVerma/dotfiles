local icons = require("config").icons
local util = require("util")

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    ---@type util.lualine.config
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
          -- stylua: ignore
          { function() return vim.fs.basename(util.root.dir()) end, icon = icons.misc.RootDir, color = util.ui.fg("Special") },
          {
            "diagnostics",
            ---@type {error?: string, warn?: string , info?: string, hint?: string}
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { "filetype", icon_only = true, separator = "" },

          -- Display the file path for current buffer and highlight the basename when unsaved changes exist.
          { util.lualine.get_dir, separator = "", padding = 0 },
          {
            -- stylua: ignore
            function() return vim.fn.expand("%:t") end,
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
          -- stylua: ignore
          { function() return os.date("%R") end, icon = icons.misc.clock },
        },
      },
      extensions = { "neo-tree", "lazy" },
    },
  },
}
