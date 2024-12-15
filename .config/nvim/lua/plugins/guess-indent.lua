---@module "guess-indent"
---@class plugins.guess_indent.config: GuessIndentConfig

---@type LazyPluginSpec[]
return {
  {
    "NMAC427/guess-indent.nvim",
    event = "LazyFile",
    ---@type plugins.guess_indent.config
    opts = {},
  },
}
