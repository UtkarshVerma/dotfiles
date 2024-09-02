---@module "nvim-treesitter"
---@module "lazy"

---@class plugins.treesitter.plugin
---@field enable? boolean
---@field disable? fun(filetype:string, bufnr: number):boolean

---@class plugins.treesitter.highlight: plugins.treesitter.plugin

---@class plugins.treesitter.config: TSConfig
---@field ensure_installed? string[]
---@field highlight? plugins.treesitter.highlight

local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    event = "LazyFile",
    version = false, -- v0.9.2 causes crashes when parsing gohtml files.
    cmd = {
      "TSUpdateSync",
      "TSUpdate",
      "TSInstall",
    },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type plugins.treesitter.config
    opts = {
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          return util.buf_has_large_file(bufnr)
        end,
      },
      indent = { enable = true },
      ensure_installed = {},
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
