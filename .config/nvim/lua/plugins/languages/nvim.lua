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
    "folke/neodev.nvim",
    opts = {},
  },

  {
    "nvim-lspconfig",
    dependencies = { "neodev.nvim" },
  },
}
