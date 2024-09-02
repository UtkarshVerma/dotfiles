---@module "lazy"
---@module "lazydev"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "vim",
      })
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    ---@type lazydev.Config
    opts = {},
  },

  {
    "nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
  },
}
