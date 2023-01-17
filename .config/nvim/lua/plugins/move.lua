return {
  "echasnovski/mini.move",
  keys = function(plugin, _)
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    return {
      opts.mappings.left,
      opts.mappings.right,
      opts.mappings.down,
      opts.mappings.up,

      { opts.mappings.line_left, mode = "v" },
      { opts.mappings.line_right, mode = "v" },
      { opts.mappings.line_down, mode = "v" },
      { opts.mappings.line_up, mode = "v" },
    }
  end,
  opts = {
    mappings = {
      -- Visual selection mappings
      left = "<a-left>",
      right = "<a-right>",
      down = "<a-down>",
      up = "<alt-up>",

      -- Normal mode mappings
      line_left = "<a-left>",
      line_right = "<a-right>",
      line_down = "<a-down>",
      line_up = "<a-up>",
    },
  },
  config = function(_, opts)
    require("mini.move").setup(opts)
  end,
}
