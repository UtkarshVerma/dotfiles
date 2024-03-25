---@class plugins.ufo.config: UfoConfig

---@type LazyPluginSpec[]
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async" },
    ---@type plugins.ufo.config
    opts = {
      open_fold_hl_timeout = 0, -- Disable fold highlight.
    },
  },
}
