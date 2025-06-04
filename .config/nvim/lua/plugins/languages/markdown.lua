---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },

  {
    "bullets-vim/bullets.vim",
    ft = "markdown",
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        marksman = {},
      },
    },
  },

  {
    "nvim-lint",
    ---@type plugins.lint.config
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
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        -- TODO: Sel line length to colorcolumn - 1
        markdown = { "prettierd" },
      },
    },
  },
}
