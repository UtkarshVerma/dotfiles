return {
  {
    "nvim-lspconfig",
    dependencies = {
      {
        "folke/neodev.nvim",
        version = false, -- Last release is way too old for neovim v0.9.5.
        opts = {},
      },
    },
  },

  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "vim" })
    end,
  },
}
