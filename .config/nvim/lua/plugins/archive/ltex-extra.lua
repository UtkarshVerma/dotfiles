---@class plugins.ltex_extra.config
---@field load_langs? string[]
---@field path? string
---@field server_opts? lsp.base

---@LazyPluginSpec[]
return {
  {
    "barreiroleo/ltex_extra.nvim",
    enabled = false,
    ft = { "markdown", "tex" },
    dependencies = { "nvim-lspconfig" },
    ---@type plugins.ltex_extra.config
    opts = {
      load_langs = { "en-GB" },
      path = vim.fn.expand("~/.local/state/ltex/"),
      server_opts = {
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
  },
}
