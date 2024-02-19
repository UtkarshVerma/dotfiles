---@class plugins.neogen.opts
---@field snippet_engine? "luasnip"|"snippy"|"vsnip"
---@field languages? table<string, neogen.Configuration>

---@type LazyPluginSpec[]
return {
  {
    "danymat/neogen",
    keys = {
      -- stylua: ignore
      {"<leader>cn", function() require("neogen").generate({}) end, desc = "Generate annotations"},
    },
    dependencies = {
      "nvim-treesitter",
      "LuaSnip",
    },
    ---@type plugins.neogen.opts
    opts = {
      snippet_engine = "luasnip",
      languages = {
        ---@diagnostic disable-next-line: missing-fields
        lua = {
          ---@diagnostic disable-next-line: missing-fields
          template = {
            annotation_convention = "emmylua",
          },
        },
      },
    },
  },
}
