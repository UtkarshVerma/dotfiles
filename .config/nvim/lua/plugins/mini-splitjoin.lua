---@alias plugins.mini.splitjoin.hook fun(positions: integer[]):integer[]

---@class plugins.mini.splitjoin.config.hooks
---@field hooks_pre? plugins.mini.splitjoin.hook[]
---@field hooks_post? plugins.mini.splitjoin.hook[]

---@class plugins.mini.splitjoin.config
---@field split? plugins.mini.splitjoin.config.hooks
---@field join? plugins.mini.splitjoin.config.hooks
---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.splitjoin",
    keys = { "gS" },
    opts = function(_, _)
      local splitjoin = require("mini.splitjoin")

      ---@type plugins.mini.splitjoin.config
      return {
        join = {
          hooks_post = {
            splitjoin.gen_hook.del_trailing_separator(),
            splitjoin.gen_hook.pad_brackets(),
          },
        },
      }
    end,
  },
}
