---@module "lazy.types"
---@class plugins.catppuccin.config: CatppuccinOptions

---@type LazyPluginSpec[]
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    ---@type plugins.catppuccin.config
    opts = {
      color_overrides = {
        mocha = require("util").colors,
      },
      integrations = {
        alpha = false,
        cmp = true,
        coc_nvim = false,
        dap = true,
        dap_ui = true,
        dashboard = true,
        flash = false,
        fidget = true,
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
          -- Workaround for https://github.com/catppuccin/nvim/issues/670.
          NeoTreeWinSeparator = { fg = colors.base, bg = colors.none },
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
