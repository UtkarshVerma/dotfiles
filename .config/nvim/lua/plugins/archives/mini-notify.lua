---@class plugins.mini_notify.config.window
---@field config? vim.window.opts|fun(id:integer):vim.window.opts
---@field max_width_share? number
---@field winblend? number

---@class plugins.mini_notify.notification
---@field msg string
---@field level string
---@field hl_group string
---@field ts_add number
---@field ts_update number
---@field ts_remove? number

---@class plugins.mini_notify.config
---@field content? {format?: fun(notification:plugins.mini_notify.notification):string}
---@field lsp_progress? {enable?: boolean}
---@field window? plugins.mini_notify.config.window

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.notify",
    event = "VeryLazy",
    init = function(_)
      vim.notify = require("mini.notify").make_notify()
    end,
    ---@type plugins.mini_notify.config
    opts = {
      content = {
        format = function(notification)
          return notification.msg
        end,
      },
      lsp_progress = {
        enable = false,
      },
      window = {
        config = {
          border = "solid",
        },
      },
    },
  },
}
