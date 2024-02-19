---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "toml",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        taplo = {},
      },
    },
  },
}
