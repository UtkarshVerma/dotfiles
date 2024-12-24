-- Borrowed from:
-- https://github.com/tamasfe/taplo/blob/18b86da66a6f75d8e974820ab2e82d88047ce7ed/editors/vscode/package.json#L157

---@class lsp.taplo.config.settings.formatter
---@field inlineTableExpand? boolean

---@class lsp.taplo.config.settings
---@field formatter? lsp.taplo.config.settings.formatter

---@class lsp.taplo.config: plugins.lspconfig.config.server
---@field settings? {evenBetterToml?: lsp.taplo.config.settings}

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "toml",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.taplo.config
        taplo = {
          settings = {
            evenBetterToml = {
              formatter = {
                inlineTableExpand = false,
              },
            },
          },
        },
      },
    },
  },
}
