return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gosum",
        "gowork",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        gopls = {},
      },
    },
  },
}
