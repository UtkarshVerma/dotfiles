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
        -- TODO: Switch to biome lsp in nvim v0.10
        tsserver = {
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
        biome = {},
      },
    },
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        -- TODO: This is slower. Prefer biome lsp which will be supported in nvim v0.10
        javascript = { "biomejs" },
        typescript = { "biomejs" },
      },
      formatters = {
        biomejs = function(_)
          local conform_util = require("conform.util")

          return {
            command = conform_util.from_node_modules("biome"),
            stdin = true,
            cwd = conform_util.root_file({
              "biome.json",
            }),
            args = {
              "format",
              "--stdin-file-path",
              "$FILENAME",
              "--indent-style=" .. (vim.o.expandtab and "space" or "tab"),
              "--indent-width=" .. vim.o.shiftwidth,
              "--line-width=" .. (tonumber(vim.o.colorcolumn) or 80),
            },
          }
        end,
      },
    },
  },
}
