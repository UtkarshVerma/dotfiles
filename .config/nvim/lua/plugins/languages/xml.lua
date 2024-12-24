--- Borrowed from: https://github.com/eclipse-lemminx/lemminx/blob/main/docs/Configuration.md

---@class lsp.lemminx.config.settings.format
---@field enabled? boolean is able to format document
---@field splitAttributes? boolean each attribute is formatted onto new line
---@field joinCDATALines? boolean normalize content inside CDATA
---@field joinCommentLines? boolean normalize content inside comments
---@field formatComments? boolean keep comment in relative position
---@field joinContentLines? boolean normalize content inside elements
---@field spaceBeforeEmptyCloseTag? boolean insert whitespace before self closing tag end bracket

---@class lsp.lemminx.config.settings.xml
---@field catalogs? string[]
---@field format? lsp.lemminx.config.settings.format

---@class lsp.lemminx.config.settings
---@field xml? lsp.lemminx.config.settings.xml

---@class lsp.lemminx.config: plugins.lspconfig.config.server
---@field settings? lsp.lemminx.config.settings

local catalogs = vim.split(os.getenv("XML_CATALOG_FILES") or "", " ", { trimempty = true })
catalogs[#catalogs + 1] = "/etc/xml/catalog"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "xml",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.lemminx.config
        lemminx = {
          settings = {
            xml = {
              catalogs = catalogs,
              format = {
                enabled = true,
                formatComments = true,
              },
            },
          },
        },
      },
    },
  },
}
