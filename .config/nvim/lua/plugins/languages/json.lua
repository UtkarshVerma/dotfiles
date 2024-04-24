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
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
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
