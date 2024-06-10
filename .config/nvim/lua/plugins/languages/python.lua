-- Borrowed from https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
---@class dap.debugpy.config: plugins.nvim_dap.configuration
---@field program string Absolute path to the program.

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
      })
    end,
  },

  {
    "mason.nvim",
    ---@param opts plugins.mason.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "debugpy",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        pyright = {},
        ruff_lsp = {
          on_attach = function(client, _)
            client.server_capabilities.hoverProvider = false
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
