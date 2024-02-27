---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
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
    ---@type plugins.lint.config
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
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "--indent", tostring(vim.o.shiftwidth or 4), "--case-indent" },
        },
      },
    },
  },
}
