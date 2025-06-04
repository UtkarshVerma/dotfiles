---@module "ufo"
---@class plugins.ufo.config: UfoConfig
---@field provider_selector? fun(bufnr:number, filetype:string, buftype:string):UfoProviderEnum[]

---@type LazyPluginSpec[]
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    version = false, -- Wait for a new release. https://github.com/kevinhwang91/nvim-ufo/issues/254
    dependencies = { "kevinhwang91/promise-async" },
    init = function(_)
      vim.opt.foldlevelstart = 99 -- Open all folds on startup
    end,
    ---@type plugins.ufo.config
    opts = {
      open_fold_hl_timeout = 0, -- Disable fold highlight.
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
    },
  },
}
