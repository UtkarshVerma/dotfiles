---@class plugins.luasnip.config
---@field region_check_events? string
---@field delete_check_events? string
---@field update_events? string[]

---@type LazyPluginSpec[]
return {
  {
    "L3MON4D3/LuaSnip",
    build = "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp",
    ---@type plugins.luasnip.config
    opts = {
      region_check_events = "CursorHold,CursorMoved,InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",

      -- For dynamic snippets.
      -- update_events = { "TextChanged", "TextChangedI" },
    },
    config = function(_, opts)
      local luasnip = require("luasnip")
      luasnip.setup(opts)

      require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/lua/snippets" } })
    end,
  },
}
