-- Borrowed from https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
---@class dap.debugpy.config: plugins.nvim_dap.configuration
---@field program string Absolute path to the program.

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "python",
      },
    },
  },

  {
    "mason.nvim",
    ---@type plugins.mason.config
    opts = {
      ensure_installed = {
        "debugpy",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true, -- Use ruff for organizing imports.
            },
            python = {
              analysis = {
                ignore = { "*" }, -- Exclusively use ruff for linting.
              },
            },
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        ruff = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false -- Use pyright for hover.
          end,
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize imports",
            },
          },
        },
      },
    },
  },

  {
    "nvim-dap",
    ---@type plugins.nvim_dap.config
    opts = {
      adapters = {
        debugpy = {
          type = "executable",
          command = "debugpy-adapter",
          options = {
            source_filetype = "python",
          },
        },
      },
      configurations = {
        ---@type dap.debugpy.config[]
        python = {
          {
            type = "debugpy",
            request = "launch",
            name = "Launch file",

            program = "${file}",
          },
        },
      },
    },
  },
}
