return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "lua",
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            format = { enable = false },
            Lua = {
              workspace = { checkThirdParty = false },
              completion = {
                callSnippet = "Replace",

                -- Don't be redundant with cmp-buffer
                workspaceWord = false,
                showWord = "Disable",
              },
              telemetry = { enable = false },
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
        lua = { "stylua" },
      },
    },
  },
}
