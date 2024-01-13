return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "html",
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  {
    "nvim-lspconfig",
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
    opts = {
      formatters_by_ft = {
        html = { "prettierd" },
      },
    },
  },
}
