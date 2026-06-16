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
    branch = "main",
    version = false,
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(_)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          -- Enable treesitter highlighting and disable regex syntax
          pcall(vim.treesitter.start)
          -- Enable treesitter-based indentation
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    opts_extend = { "ensure_installed" },
    ---@type plugins.treesitter.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
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

      require("nvim-treesitter").setup(opts)
      local installed = require('nvim-treesitter.config').get_installed()
      local to_install = vim.iter(opts.ensure_installed)
          :filter(function(parser)
            return not vim.tbl_contains(installed, parser)
          end)
          :totable()
      require('nvim-treesitter').install(to_install)
    end,
  },
}
