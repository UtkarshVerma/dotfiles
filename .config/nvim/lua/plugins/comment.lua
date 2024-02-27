---@type LazyPluginSpec[]
return {
  {
    "numToStr/Comment.nvim",
    event = "LazyFile",
    ---@type CommentConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      mappings = {
        basic = true,
        extra = true,
      },

      -- Ignore empty lines.
      ignore = "^$",
    },
  },
}
