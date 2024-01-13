return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "zig",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        zls = {},
      },
    },
  },
}
