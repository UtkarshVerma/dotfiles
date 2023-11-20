return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          cmd_env = {
            INCLUDE_ALL_WORKSPACE_SYMBOLS = true,
          },
        },
      },
    },
  },

  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
      linters = {
        shellcheck = {
          prepend_args = {
            "-x",
          },
        },
      },
    },
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "--indent", vim.o.shiftwidth or 4, "--case-indent" },
        },
      },
    },
  },
}
