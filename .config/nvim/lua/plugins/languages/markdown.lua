return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "markdown",
        "markdown_inline",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "vale" },
      },
      linters = {
        vale = {
          prepend_args = {
            "--config",
            vim.fn.expand("~/.config/vale/config.ini"),
          },
        },
      },
    },
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettierd" },
      },
    },
  },
}
