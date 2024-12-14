---@module "Comment"
---@class plugins.comment.config: CommentConfig

---@type LazyPluginSpec[]
return {
  {
    "numToStr/Comment.nvim",
    event = "LazyFile",
    ---@type plugins.comment.config
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
