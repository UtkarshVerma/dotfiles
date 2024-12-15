---@alias plugins.mini.move.config.mapping_key
--- |"left"
--- |"right"
--- |"down"
--- |"up"
--- |"line_left"
--- |"line_right"
--- |"line_down"
--- |"line_up"
---@alias plugins.mini.move.config.mappings table<plugins.mini.move.config.mapping_key,string>

---@class plugins.mini.move.config
---@field mappings? plugins.mini.move.config.mappings

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.move",
    keys = function(plugin, _)
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)

      return {
        { opts.mappings.left, mode = "v" },
        { opts.mappings.right, mode = "v" },
        { opts.mappings.down, mode = "v" },
        { opts.mappings.up, mode = "v" },

        opts.mappings.line_left,
        opts.mappings.line_right,
        opts.mappings.line_down,
        opts.mappings.line_up,
      }
    end,
    ---@type plugins.mini.move.config
    opts = {
      mappings = {
        -- Visual selection mappings
        left = "<a-h>",
        right = "<a-l>",
        down = "<a-j>",
        up = "<a-k>",

        -- Normal mode mappings
        line_left = "<a-h>",
        line_right = "<a-l>",
        line_down = "<a-j>",
        line_up = "<a-k>",
      },
    },
  },
}
