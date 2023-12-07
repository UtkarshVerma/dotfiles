return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dockerfile",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
      },
    },
  },
}
