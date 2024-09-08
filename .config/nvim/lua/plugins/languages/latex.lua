---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "latex",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        texlab = {},
      },
    },
  },

  {
    "conform.nvim",
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        tex = { "latexindent" },
      },
      formatters = {
        latexindent = {
          prepend_args = {
            "--logfile=/tmp/indent.log", -- Don't generate indent.log in project
          },
        },
      },
    },
  },
}
