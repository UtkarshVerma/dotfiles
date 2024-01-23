---@type LazyPluginSpec[]
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-web-devicons" },
    -- stylua: ignore
    keys = {
      { "-", function() require("oil").open() end, mode = "n", desc = "Open parent directory" },
    },
    opts = {},
  },
}
