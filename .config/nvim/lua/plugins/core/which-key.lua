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
    opts_extend = { "spec" },
    ---@type plugins.which_key.config
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

      -- spec = {
      -- },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },
}
