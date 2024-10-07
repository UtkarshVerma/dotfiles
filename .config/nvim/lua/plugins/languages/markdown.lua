---@type LazyPluginSpec[]
return {
  {
    "bullets-vim/bullets.vim",
    ft = "markdown",
  },

  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended since the plugin lazy-loads itself.
    dependencies = {
      "nvim-treesitter",
      "nvim-web-devicons",
    },
  },

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
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
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
        -- TODO: Set line length to colorcolumn - 1
        markdown = { "prettierd" },
      },
    },
  },
}
