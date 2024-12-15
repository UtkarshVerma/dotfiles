---@class plugins.indent_blankline.config: ibl.config

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
