---@module "which-key"
---@class plugins.which_key.config: wk.Config

---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        which_key = true,
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-web-devicons",
    },
    opts_extend = { "spec" },
    ---@type plugins.which_key.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      preset = "classic",
      icons = {
        mappings = false,
      },
      win = {
        wo = {
          winblend = 5,
        },
      },
      spec = {
        { "g", group = "goto" },
        { "]", group = "next" },
        { "[", group = "prev" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "haskell" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>t", group = "toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
      },
    },
  },
}
