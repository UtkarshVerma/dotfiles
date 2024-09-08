---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "html",
      },
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        emmet_language_server = {},
        html = {
          init_options = {
            provideFormatter = false, -- We'll use prettierd
          },
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
            },
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
        html = { "prettierd" },
      },
    },
  },
}
