---@type LazyPluginSpec[]
return {
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>tu", "<cmd>UndotreeToggle<cr>", desc = "Undotree" },
    },
  },
}
