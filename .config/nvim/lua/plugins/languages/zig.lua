---@module "lazy.types"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "zig",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        zls = {},
      },
    },
  },
}
