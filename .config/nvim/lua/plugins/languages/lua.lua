---@class lsp.lua_ls.config.settings
---@field format? { enabled?: boolean}
---@field Lua? { workspace?: { checkThirdParty?: boolean } }

---@class lsp.lua_ls.config: lsp.base
---@field settings? lsp.lua_ls.config.settings

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "lua",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.lua_ls.config
        lua_ls = {
          settings = {
            format = { enable = false },
            Lua = {
              workspace = {
                checkThirdParty = false,
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
        lua = { "stylua" },
      },
    },
  },
}
