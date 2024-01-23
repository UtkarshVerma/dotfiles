---@type LazyPluginSpec[]
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async" },
    ---@type UfoConfig
    opts = {
      open_fold_hl_timeout = 0, -- Disable fold highlight
      provider_selector = function(_, _, _)
        ---@type UfoProviderEnum
        return { "treesitter", "indent" }
      end,
    },
  },
}
