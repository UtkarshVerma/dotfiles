return {
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>uz", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" },
    },
    -- TODO: Hide lualine
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
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.diagnostic.is_disabled(bufnr) then
          vim.b[bufnr].restore_diagnostics = true
          vim.diagnostic.disable(bufnr)
        end
      end,
      on_close = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.b[bufnr].restore_diagnostics then
          vim.diagnostic.enable(bufnr)
        end
      end,
    },
  },

  { "barreiroleo/ltex_extra.nvim" },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
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
}
