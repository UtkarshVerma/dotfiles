return {
  {
    "nvim-lspconfig",
    dependencies = {
      {
        "folke/neodev.nvim",
        opts = {},
      },
    },
  },

  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "vim",
      })
    end,
  },
}
