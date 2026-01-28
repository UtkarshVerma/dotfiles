---@module "codesettings"
---@class plugins.codesettings.config: CodesettingsSettings

---@type LazyPluginSpec[]
return {
  {
    "mrjones2014/codesettings.nvim",
    cmd = "Codesettings",
    -- Recommended by the author to load on these filetypes for jsonls integration.
    ft = { "json", "jsonc" },
    init = function()
      vim.lsp.config("*", {
        before_init = function(_, config)
          config = require("codesettings").with_local_settings(config.name, config)
        end,
      })
    end,
    ---@type plugins.codesettings.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
  },
}
