---@class plugins.treesitter_context.config
---@field max_lines? integer
---@field mode? "cursor"|"topline"
---@field on_attach? fun(bufnr:number):boolean

local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    dependencies = { "nvim-treesitter" },
    ---@type plugins.treesitter_context.config
    opts = {
      max_lines = 2,
    },
  },
}
