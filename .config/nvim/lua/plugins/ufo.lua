---@module "ufo"
---@class plugins.ufo.config: UfoConfig
---@field provider_selector? fun(bufnr:number, filetype:string, buftype:string):UfoProviderEnum[]

local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = { "kevinhwang91/promise-async" },
    init = function(_)
      vim.opt.foldlevelstart = 99 -- Open all folds on startup
    end,
    ---@type plugins.ufo.config
    opts = {
      open_fold_hl_timeout = 0, -- Disable fold highlight.
      provider_selector = function(bufnr, _, _)
        if util.buf_has_large_file(bufnr) then
          return { "indent" }
        end

        return { "treesitter", "indent" }
      end,
    },
  },
}
