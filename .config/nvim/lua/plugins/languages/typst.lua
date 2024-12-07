---@class lsp.typst_lsp.config.settings
---@field exportPdf? "onType"|"onSave"|"never"
---@field serverPath? string

---@class lsp.typst_lsp.config: lsp.base
---@field settings? lsp.typst_lsp.config.settings

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "typst",
      },
    },
  },

  {
    "kaarmu/typst.vim",
    ft = "typst",
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.typst_lsp.config
        tinymist = {
          offset_encoding = "utf-8", -- HACK: Fix after nvim 0.10.3 releases
        },
      },
    },
  },

  {
    "conform.nvim",
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        typst = { "typstyle" },
      },
    },
  },
}
