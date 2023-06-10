return {
  { "folke/tokyonight.nvim" },
  { "catppuccin/nvim" },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    keys = { { "<leader>c", "<cmd>MonokaiProSelect<cr>", desc = "Select Moonokai pro filter" } },
    config = function()
      local monokai = require("monokai-pro")
      monokai.setup({
        transparent_background = false,
        devicons = true,
        filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
        day_night = {
          enable = false,
          day_filter = "classic",
          night_filter = "octagon",
        },
        inc_search = "background", -- underline | background
        background_clear = { "nvim-tree", "neo-tree", "bufferline" },
        plugins = {
          bufferline = {
            underline_selected = true,
            underline_visible = false,
            underline_fill = true,
            bold = false,
          },
          indent_blankline = {
            context_highlight = "pro", -- default | pro
            context_start_underline = true,
          },
        },
        override = function(c)
          return {
            ColorColumn = { bg = c.base.dimmed3 },
            -- Mine
            DashboardRecent = { fg = c.base.magenta },
            DashboardProject = { fg = c.base.blue },
            DashboardConfiguration = { fg = c.base.white },
            DashboardSession = { fg = c.base.green },
            DashboardLazy = { fg = c.base.cyan },
            DashboardServer = { fg = c.base.yellow },
            DashboardQuit = { fg = c.base.red },
          }
        end,
      })
      monokai.load()
    end,
  },
  {
    "UtkarshVerma/molokai.nvim",
    enabled = false,
    dir = "~/git/molokai.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    config = function(_, opts)
      local molokai = require("molokai")
      molokai.setup(opts)
      molokai.load()
    end,
  },
}
