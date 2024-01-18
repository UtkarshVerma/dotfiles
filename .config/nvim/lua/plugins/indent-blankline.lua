local icons = require("config").icons

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "LazyFile",
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
