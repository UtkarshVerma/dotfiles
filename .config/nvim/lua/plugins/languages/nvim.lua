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
    "blink.cmp",
    ---@type plugins.blink.config
    opts = {
      sources = {
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- Make lazydev completions top priority.
            score_offset = 100,
          },
        },
      },
    },
  },
}
