return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
    },
    opts = {
      window = {
        backdrop = 0.95,
        width = tonumber(vim.o.colorcolumn or "80") + 7,
        height = 1,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
          cursorline = false,
          colorcolumn = "0",
          foldcolumn = "0",
          list = false,
        },
      },
      on_open = function(_)
        if not vim.diagnostic.is_disabled(0) then
          vim.b.restore_diagnostics = true
          vim.diagnostic.disable(0)
        end
      end,
      on_close = function()
        if vim.b.restore_diagnostics then
          vim.diagnostic.enable(0)
        end
      end,
    },
  },

  {
    "nvim-lspconfig",
    dependencies = { "barreiroleo/ltex_extra.nvim" },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
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
          ltex = function(_, server_opts)
            server_opts.on_attach = function(_, _)
              require("ltex_extra").setup({
                load_langs = { "en-GB" },
                path = vim.fn.expand("~/.local/state/ltex/"),
              })
            end
          end,
        },
      })
    end,
  },

  {
    "none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")

      opts.sources = opts.sources or {}
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.vale.with({
          extra_args = { "--config", vim.fn.expand("~/.config/vale/config.ini") },
        }),
      })
    end,
  },
}
