---@class plugins.indent_blankline.config
---@field exclude? {filetypes?: string[]}
---@field indent? {char?: string, tab_char?: string, priority?: integer}

local icons = require("config").icons

---@type LazyPluginSpec[]
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "LazyFile",
    ---@type plugins.indent_blankline.config
    opts = {
      exclude = {
        filetypes = {
          "help",
          "lazy",
          "lazyterm",
          "dashboard",
          "neo-tree",
          "mason",
          "notify",
          "Trouble",
        },
      },
      indent = {
        char = icons.indent.inactive,
        tab_char = icons.indent.inactive,
        priority = 11,
      },
    },
  },
}
