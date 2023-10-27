return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "yaml",
      })
    end,
  },

  {
    "mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "yamllint",
        "yamlfmt",
      })
    end,
  },

  {
    "nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
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
        yamlls = function(server, opts)
          opts.settings.yaml["schemas"] = require("schemastore").yaml.schemas()
          require("lspconfig")[server].setup(opts)
          return true
        end,
      },
    },
  },

  {
    "nvim-lint",
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
              tonumber(vim.o.colorcolumn or "80") - 1
            ),
          },
        },
      },
    },
  },

  {
    "conform.nvim",
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
              tonumber(vim.o.colorcolumn or "80") - 1
            ),
          },
        },
      },
    },
  },
}
