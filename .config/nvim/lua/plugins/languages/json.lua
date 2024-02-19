return {
  {
    "nvim-treesitter",
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
    version = false, -- last release is way too old
  },

  {
    "nvim-lspconfig",
    dependencies = { "SchemaStore.nvim" },
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
    opts = {
      formatters_by_ft = {
        json = { "biome" },
      },
    },
  },
}
