local palette = require("util.colors")

---@type LazyPluginSpec[]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    ---@type CatppuccinOptions
    opts = {
      color_overrides = {
        -- TODO: Compute other colors from the base 16 palette.
        mocha = {
          rosewater = palette.special.cursor,
          flamingo = "#f2cdcd",
          pink = palette.normal.magenta,
          mauve = "#cba6f7",
          red = palette.normal.red,
          maroon = "#eba0ac",
          peach = "#fab387",
          yellow = palette.normal.yellow,
          green = palette.normal.green,
          teal = palette.normal.cyan,
          sky = "#89dceb",
          sapphire = "#74c7ec",
          blue = palette.normal.blue,
          lavender = "#b4befe",
          text = palette.special.foreground,
          subtext1 = palette.normal.white,
          subtext0 = palette.bright.white,
          overlay2 = "#9399b2",
          overlay1 = "#7f849c",
          overlay0 = "#6c7086",
          surface2 = palette.bright.black,
          surface1 = palette.normal.black,
          surface0 = "#313244",
          base = palette.special.background,
          mantle = "#181825",
          crust = "#11111b",
        },
      },
      integrations = {
        alpha = false,
        cmp = true,
        coc_nvim = false,
        dap = true,
        dap_ui = true,
        dashboard = true,
        flash = false,
        gitsigns = true,
        illuminate = false,
        indent_blankline = true,
        mini = true,
        native_lsp = {
          enabled = true,
        },
        neotree = true,
        noice = true,
        notify = true,
        nvimtree = false,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        treesitter = true,
        treesitter_context = true,
        ufo = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          -- Workaround for https://github.com/catppuccin/nvim/issues/670
          NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
          MiniNotifyBorder = { link = "MiniNotifyNormal" },
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
