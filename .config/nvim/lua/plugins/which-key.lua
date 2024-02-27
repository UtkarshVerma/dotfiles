---@class plugins.which_key.defaults
---@field [string] {name: string}
---@field mode? ("n"|"v")[]

---@class plugins.which_key.config
---@field defaults? plugins.which_key.defaults
---@field key_labels? table<string, string>

---@type LazyPluginSpec[]
return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@type plugins.which_key.config
    opts = {
      plugins = {
        spelling = true,
        presets = { motions = false, g = false }, -- This fix mapping for fold when press f and nothing show up
      },
      key_labels = {
        ["<Tab>"] = "<tab>",
      },
      layout = {
        height = { min = 3, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 5, -- spacing between columns
        align = "center", -- align columns left, center or right
      },
      window = {
        margin = { 1, 0, 2, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 5, -- value between 0-100 0 for fully opaque and 100 for fully transparent
      },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>a"] = { name = "+ai" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debug" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>t"] = { name = "+toggle" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
}
