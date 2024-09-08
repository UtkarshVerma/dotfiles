---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "css",
        "scss",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        cssls = {
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
        css = { "prettierd" },
        scss = { "prettierd" },
      },
    },
  },
}
