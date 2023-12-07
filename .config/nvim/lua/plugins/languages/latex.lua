return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "latex",
      })
    end,
  },

  {
    "nvim-lspconfig",
    dependencies = { "barreiroleo/ltex_extra.nvim" },
    opts = {
      servers = {
        texlab = {},
      },
    },
  },

  {
    "conform.nvim",
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
