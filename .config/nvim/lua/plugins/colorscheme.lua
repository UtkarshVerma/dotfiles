return {
  {
    "folke/tokyonight.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "VeryLazy",
    opts = {
      integrations = {
        nvimtree = false,
        neotree = true,
        leap = true,
        telescope = true,
        noice = true,
        notify = true,
        mini = true,
        which_key = true,
      },
      custom_highlights = function(c)
        return {
          ColorColumn = { bg = c.mantle },

          -- Mine
          DashboardRecent = { fg = c.pink },
          DashboardProject = { fg = c.blue },
          DashboardConfiguration = { fg = c.base.white },
          DashboardSession = { fg = c.green },
          DashboardLazy = { fg = c.sky },
          DashboardServer = { fg = c.yellow },
          DashboardQuit = { fg = c.red },
        }
      end,
    },
  },

  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "nvim-web-devicons" },
    opts = {
      transparent_background = false,
      devicons = true,
      filter = "spectrum",
      day_night = {
        enable = false,
        day_filter = "classic",
        night_filter = "octagon",
      },
      inc_search = "background",
      background_clear = {},
      plugins = {
        bufferline = {
          underline_selected = true,
          underline_visible = false,
          underline_fill = false,
          bold = false,
        },
        indent_blankline = {
          context_highlight = "pro",
          context_start_underline = false,
        },
      },
      override = function(c)
        return {
          ColorColumn = { bg = c.base.dimmed5 },
          NonText = { fg = c.base.dimmed5 },
          LspCodeLens = { link = "Comment" },

          IblIndent = { link = "IndentBlanklineChar" },
          IblScope = { link = "IndentBlanklineContextChar" },
          IblWhitespace = { link = "IndentBlanklineSpaceChar" },

          DashboardRecent = { fg = c.base.magenta },
          DashboardProject = { fg = c.base.blue },
          DashboardConfiguration = { fg = c.base.white },
          DashboardSession = { fg = c.base.green },
          DashboardLazy = { fg = c.base.cyan },
          DashboardServer = { fg = c.base.yellow },
          DashboardQuit = { fg = c.base.red },
        }
      end,
    },
    config = function(_, opts)
      local monokai = require("monokai-pro")
      monokai.setup(opts)
      monokai.load()
    end,
  },
}
