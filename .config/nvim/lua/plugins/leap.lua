return {
  {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  {
    "ggandor/flit.nvim",
    keys = {
      { "f", mode = { "n", "x", "o" }, desc = "Move forward to" },
      { "F", mode = { "n", "x", "o" }, desc = "Move backward to" },
      { "t", mode = { "n", "x", "o" }, desc = "Move forward until" },
      { "T", mode = { "n", "x", "o" }, desc = "Move backward until" },
    },
    opts = {
      labeled_modes = "nx",
    },
  },
}
