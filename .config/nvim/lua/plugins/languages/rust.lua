---@module "rustaceanvim"
---@class plugins.crates.config: crates.UserConfig

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "ron",
        "rust",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.taplo.config
        ---@diagnostic disable-next-line: missing-fields
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                else
                  require("crates").show_popup()
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show crate documentation",
            },
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        rust_analyzer = {},
      },
    },
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    tag = "stable",
    ---@type plugins.crates.config
    opts = {
      completion = {
        crates = {
          enabled = false,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
