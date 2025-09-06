---@type LazyPluginSpec[]
return {
  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        mojo = {},
      },
    },
  },
}
