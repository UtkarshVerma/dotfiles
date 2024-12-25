---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "zig",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        zls = {},
      },
    },
  },

  {
    "neotest",
    dependencies = { "lawrence-laz/neotest-zig" },
    ---@type plugins.neotest.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      adapters = {
        ["neotest-zig"] = {},
      },
    },
  },
}
