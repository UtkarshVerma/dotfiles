---@module "lazy"
---@module "which-key"

---@class plugins.which_key.config: wk.Config

---@type LazyPluginSpec[]
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-web-devicons",
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
    ---@type plugins.which_key.config
    opts = {
      preset = "classic",
      layout = {
        height = { min = 3, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      icons = {
        rules = false,
      },
      win = {
        padding = { 1, 2 },
        wo = {
          winblend = 5, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
      },

      spec = {
        mode = { "n", "v" },
        { "g", group = "goto" },
        { "gz", group = "surround" },
        { "]", group = "next" },
        { "[", group = "prev" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui" },
        { "<leader>t", group = "toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
