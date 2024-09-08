---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "ron",
        "rust",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        rust_analyzer = {
          setup = function(_)
            -- Do not initialize the LSP as rustaceanvim will take care of that.
            return true
          end,
        },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    init = function(_)
      vim.g.rustaceanvim = {
        tools = {
          ---@type vim.window.opts
          float_win_config = {
            -- TODO: Set the color to match body background.
            border = "solid",
          },
        },
      }
    end,
  },
}
