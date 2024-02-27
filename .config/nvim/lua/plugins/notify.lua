local util = require("util")

return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all notifications",
      },
    },
    ---@type notify.Config
    -- TODO: Get rid of border
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      render = function(bufnr, notif, highlights)
        local base = require("notify.render.base")
        local namespace = base.namespace()
        local icon = notif.icon
        local title = notif.title[1]

        local prefix = string.format("%s %s:", icon, title)
        notif.message[1] = string.format("%s %s", prefix, notif.message[1])

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

        local icon_length = vim.str_utfindex(icon)
        local prefix_length = vim.str_utfindex(prefix)

        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
          hl_group = highlights.icon,
          end_col = icon_length + 1,
          priority = 50,
        })
        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, icon_length + 1, {
          hl_group = highlights.title,
          end_col = prefix_length + 1,
          priority = 50,
        })
        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, prefix_length + 1, {
          hl_group = highlights.body,
          end_line = #notif.message,
          priority = 50,
        })
      end,
      stages = "static",
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      on_open = function(win)
        vim.api.nvim_win_set_config(win, { zindex = 100 })
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      if not util.plugin.exists("noice.nvim") then
        util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
}
