---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "javascript",
        "jsdoc",
        "typescript",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        ts_ls = {
          -- Disable formatter in favour of biome.
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Remove unused imports",
            },
          },
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
          settings = {
            implicitProjectConfiguration = {
              checkJs = true, -- Check javascript types using JSDoc.
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        biome = {},
      },
    },
  },
}
