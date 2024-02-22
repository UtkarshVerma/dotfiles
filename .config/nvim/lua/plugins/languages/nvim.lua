---@type LazyPluginSpec[]
return {
  {
    "folke/neodev.nvim",
    opts = {},
  },

  {
    "nvim-lspconfig",
    dependencies = { "neodev.nvim" },
  },

  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "vim" })
    end,
  },
}
