---@class plugins.indent_blankline.config: ibl.config

local util = require("util")
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
    config = function(_, opts)
      require("ibl").setup(opts)

      -- Disable for large files.
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.ACTIVE, function(bufnr)
        return not util.buf_has_large_file(bufnr)
      end)
    end,
  },
}
