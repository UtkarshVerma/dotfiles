---@module "nvim-treesitter"

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
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: Add nvim-treesitter queries to the rtp and its custom query predicates early.
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    ---@type plugins.treesitter.config
    ---@diagnostic disable-next-line: missing-fields
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
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = util.dedup(opts.ensure_installed)
      end

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
