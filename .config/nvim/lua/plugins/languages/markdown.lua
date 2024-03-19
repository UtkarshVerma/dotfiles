---@type LazyPluginSpec[]
return {
  {
    "bullets-vim/bullets.vim",
    ft = "markdown",
  },

  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "markdown",
        "markdown_inline",
      })
    end,
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
