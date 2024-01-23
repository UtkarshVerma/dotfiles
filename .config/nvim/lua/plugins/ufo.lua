---@class plugins.ufo.config
---@field open_fold_hl_timeout? integer

---@type LazyPluginSpec[]
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async" },
    ---@type plugins.ufo.config
    opts = {
      open_fold_hl_timeout = 0, -- Disable fold highlight
    },
  },
}
