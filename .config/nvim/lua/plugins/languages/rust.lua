local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ron",
        "rust",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        rust_analyzer = {
          setup = function()
            -- Do not initialize the LSP as rustaceanvim will take care of that.
            return true
          end,
        },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^3",
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
