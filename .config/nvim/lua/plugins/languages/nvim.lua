---@module "lazydev"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "vim",
      },
    },
  },

  -- vim.uv typings.
  { "Bilal2453/luvit-meta" },

  {
    "folke/lazydev.nvim",
    dependencies = {},
    ft = "lua", -- only load on lua files
    ---@type lazydev.Config
    opts = {
      library = {
        "lazy.nvim",

        -- Load luvit types when the `vim.uv` word is found.
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
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
