---@module "lazy.types"

---@class lsp.jsonls.config.settings.json.format
---@field enable? boolean

---@class lsp.jsonls.config.settings.json.validate
---@field enable? boolean

---@class lsp.jsonls.config.settings.json
---@field format? lsp.jsonls.config.settings.json.format
---@field validate? lsp.jsonls.config.settings.json.validate

-- Borrowed from https://www.npmjs.com/package/vscode-json-languageserver#settings
---@class lsp.jsonls.config.settings
---@field json? lsp.jsonls.config.settings.json
---@field schemas? table[]

---@class lsp.jsonls.config: lsp.base
---@field settings? lsp.jsonls.config.settings

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "json",
        "json5",
        "jsonc",
      })
    end,
  },

  {
    "b0o/SchemaStore.nvim",
    version = false,
  },

  {
    "nvim-lspconfig",
    dependencies = { "SchemaStore.nvim" },
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        jsonls = {
          -- Lazy-load schemastore when needed.
          ---@param new_config lsp.jsonls.config
          on_new_config = function(new_config, _)
            new_config.settings.json["schemas"] = require("schemastore").json.schemas()
          end,
          ---@type lsp.jsonls.config
          settings = {
            json = {
              format = { enable = false },
              validate = { enable = true },
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
        json = { "biome" },
      },
    },
  },
}
