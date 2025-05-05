-- Borrowed from https://github.com/redhat-developer/yaml-language-server?tab=readme-ov-file#language-server-settings
---@class lsp.yamlls.config.settings.yaml.format
---@field enable? boolean Whether to enable formatting support.
---@field singleQuote? boolean Whether to use single quotes instead of double quotes.
---@field bracketSpacing? boolean Whether to print spaces between brackets in objects.
---@field proseWrap? "Never"|"Preserve" How to wrap prose.
---@field printWidth? number The line length that the printer will wrap on.

---@class lsp.yamlls.config.settings.yaml.schemaStore
---@field enable? boolean Whether to enable schemaStore support.
---@field url? string The URL of the schema store.

---@class lsp.yamlls.config.settings.yaml
---@field schemas? table[] The schemas to use.
---@field keyOrdering? boolean Enforces alphabetical ordering of keys in mappings when set to true. Default is `false`.
---@field hover? boolean Whether to enable hover support.
---@field completion? boolean Whether to enable completion support.
---@field validate? boolean Whether to enable validation support.
---@field format? lsp.yamlls.config.settings.yaml.format

---@class lsp.yamlls.config.settings.redhat.telemetry
---@field enabled? boolean Whether to send telemetry data to Red Hat. Default is true.

---@class lsp.yamlls.config.settings.redhat
---@field telemetry? lsp.yamlls.config.settings.redhat.telemetry

---@class lsp.yamlls.config.settings
---@field redhat? lsp.yamlls.config.settings.redhat
---@field yaml? lsp.yamlls.config.settings.yaml

---@class lsp.yamlls.config: plugins.lspconfig.config.server
---@field settings? lsp.yamlls.config.settings

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "yaml",
      },
    },
  },

  {
    "b0o/SchemaStore.nvim",
    version = false,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.yamlls.config
        ---@diagnostic disable-next-line: missing-fields
        yamlls = {
          -- Lazy-load schemastore when needed.
          ---@param new_config lsp.yamlls.config
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          -- Have to add this for yamlls to understand that we support line folding.
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              validate = false, -- Use yamllint instead.
              format = { enable = false }, -- Built-in formatter is prettier, which is slow.
              schemaStore = {
                -- Disable built-in schemaStore support in favour of the nvim plugin.
                enable = false,
                -- Avoid TypeError: Cannot read properties of undefined (reading 'length').
                url = "",
              },
            },
          },
        },
      },
    },
  },

  {
    "nvim-lint",
    ---@type plugins.lint.config
    opts = {
      linters_by_ft = {
        yaml = { "yamllint" },
      },
      linters = {
        yamllint = {
          prepend_args = {
            "-d",
            "{extends: default, rules: {document-start: disable, line-length: disable}}",
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
        yaml = { "yamlfmt" },
      },
      formatters = {
        yamlfmt = {
          prepend_args = {
            "-formatter",
            "type=basic,retain_line_breaks=true,pad_line_comments=2",
          },
        },
      },
    },
  },
}
