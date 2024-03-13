---@class plugins.zen_mode.config.plugins.gitsigns
---@field enabled? boolean If true, then disable gitsigns.

---@class plugins.zen_mode.config.plugins.options
---@field enabled? boolean If true, then disable passed options.

---@class plugins.zen_mode.config.plugins
---@field gitsigns? plugins.zen_mode.config.plugins.gitsigns
---@field options? plugins.zen_mode.config.plugins.options

---@class plugins.zen_mode.config: ZenOptions
---@field plugins? plugins.zen_mode.config.plugins

---@type LazyPluginSpec[]
return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>tz", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    ---@type plugins.zen_mode.config
    opts = {
      plugins = {
        gitsigns = { enabled = true },
        options = {
          enabled = true,
          colorcolumn = "0",
          cmdheight = 0,
        },
      },
    },
  },
}
