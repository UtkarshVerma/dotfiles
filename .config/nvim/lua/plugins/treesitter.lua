---@class plugins.treesitter.config: TSConfig
---@field ensure_installed? string[]

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
      highlight = { enable = true },
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
