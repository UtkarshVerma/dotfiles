---@class lsp.typst_lsp.config.settings
---@field exportPdf? "onType"|"onSave"|"never"
---@field serverPath? string

---@class lsp.typst_lsp.config: lsp.base
---@field settings? lsp.typst_lsp.config.settings

---@type LazyPluginSpec[]
return {
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
        typst_lsp = {},
      },
    },
  },

  {
    "conform.nvim",
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        typst = { "typstfmt" },
      },
    },
  },
}
