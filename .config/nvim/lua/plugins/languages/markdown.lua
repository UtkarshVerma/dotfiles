return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "markdown",
        "markdown_inline",
      })
    end,
  },

  {
    "nvim-lspconfig",
    dependencies = { "barreiroleo/ltex_extra.nvim" },
    opts = {
      servers = {
        marksman = {},
        texlab = {},
        ltex = {
          settings = {
            ltex = {
              language = "en-GB",
              checkFrequency = "save",
              additionalRules = {
                enablePickyRules = true,
                languageModel = "~/.local/share/ltex/ngrams/",
              },
            },
          },
        },
      },
      setup = {
        ltex = function(_, opts)
          opts.on_attach = function(_, _)
            require("ltex_extra").setup({
              load_langs = { "en-GB" },
              path = vim.fn.expand("~/.local/state/ltex/"),
            })
          end

          return false
        end,
      },
    },
  },

  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "vale" },
      },
      linters = {
        vale = {
          prepend_args = {
            "--config",
            vim.fn.expand("~/.config/vale/config.ini"),
          },
        },
      },
    },
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = { "prettierd" },
      },
    },
  },
}
