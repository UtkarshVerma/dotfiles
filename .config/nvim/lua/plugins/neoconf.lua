---@type LazyPluginSpec[]
return {
  -- neoconf must be loaded before lspconfig.
  {
    "nvim-lspconfig",
    dependencies = { "neoconf.nvim" },
  },

  {
    "folke/neoconf.nvim",
    cmd = "Neoconf",
    keys = {
      { "<leader>un", "<cmd>Neoconf<cr>", desc = "Neoconf" },
    },
    version = false, -- NOTE: v1.4.0 is buggy. Wait for the next release.
    opts = {},
  },
}
