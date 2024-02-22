---@class plugins.mini.operators.entry
---@field prefix string
---@field func? function
---@field reindent_linewise? boolean

---@alias plugins.mini.operators.operator "evaluate"|"exchange"|"multiply"|"replace"|"sort"

---@alias plugins.mini.operators.config table<plugins.mini.operators.operator, plugins.mini.operators.entry>

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.operators",
    event = "VeryLazy",
    ---@type plugins.mini.operators.config
    opts = {
      -- Evaluate text and replace with output
      evaluate = {
        prefix = "g=",
      },

      -- Exchange text regions
      exchange = {
        prefix = "gx",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Multiply (duplicate) text
      multiply = {
        prefix = "gm",

        -- Function which can modify text before multiplying
        func = nil,
      },

      -- Replace text with register
      replace = {
        prefix = "gr",

        -- Whether to reindent new text to match previous indent
        reindent_linewise = true,
      },

      -- Sort text
      sort = {
        prefix = "gs",
      },
    },
  },
}
