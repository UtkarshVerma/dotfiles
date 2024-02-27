-- TODO: Relies on lspconfig's `setup`.

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "yaml",
      })
    end,
  },

  {
    "b0o/SchemaStore.nvim",
    version = false, -- last release is way too old
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              hover = true,
              completion = true,
              validate = true,
              schemaStore = { enable = true, url = "" },
            },
          },
        },
      },
      setup = {
        yamlls = function(_, opts)
          opts.settings.yaml["schemas"] = require("schemastore").yaml.schemas()
          return false
        end,
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
            string.format(
              "{extends: default, rules: {document-start: disable, line-length: {max: %d}}}",
              (tonumber(vim.o.colorcolumn) or 80) - 1
            ),
          },
        },
      },
    },
  },

  {
    "conform.nvim",
    ---@type plugins.lspconfig.config
    opts = {
      formatters_by_ft = {
        yaml = { "yamlfmt" },
      },
      formatters = {
        yamlfmt = {
          prepend_args = {
            "-formatter",
            string.format(
              "type=basic,retain_line_breaks=true,max_line_length=%d",
              (tonumber(vim.o.colorcolumn) or 80) - 1
            ),
          },
        },
      },
    },
  },
}
