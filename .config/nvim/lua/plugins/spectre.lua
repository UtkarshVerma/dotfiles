---@type LazyPluginSpec[]
return {
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    keys = {
      -- stylua: ignore
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
    ---@type SpectreConfig
    opts = {
      open_cmd = "noswapfile vnew",
    },
  },
}
