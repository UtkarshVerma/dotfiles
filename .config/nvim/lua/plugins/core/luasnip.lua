---@class plugins.luasnip.config
---@field region_check_events? string
---@field delete_check_events? string
---@field update_events? string[]
---@field snip_env? table<string, function>

---@type LazyPluginSpec[]
return {
  {
    "blink.cmp",
    dependencies = { "LuaSnip" },
    ---@type plugins.blink.config
    opts = {
      snippets = {
        expand = function(snippet)
          require("luasnip").lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require("luasnip").jumpable(filter.direction)
          end

          return require("luasnip").in_snippet()
        end,
        jump = function(direction)
          require("luasnip").jump(direction)
        end,
      },
      sources = {
        default = { "luasnip" },
        providers = {
          luasnip = {
            score_offset = 10,
          },
        },
      },
    },
  },

  {
    "L3MON4D3/LuaSnip",
    build = "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp",
    keys = {
      {
        "<c-e>",
        function()
          local luasnip = require("luasnip")

          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end,
        mode = { "i", "s" },
      },
    },
    ---@type plugins.luasnip.config
    opts = {
      region_check_events = "CursorHold,CursorMoved,InsertEnter",
      delete_check_events = "TextChanged,InsertLeave",

      -- Don't pass any globals to snippets.
      snip_env = {},

      -- For dynamic snippets.
      update_events = { "TextChanged", "TextChangedI" },
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/lua/snippets" },
        fs_event_providers = {
          -- Reload snippets when edited in another instance.
          libuv = true,

          -- Fallback.
          autocmd = true,
        },
      })
    end,
  },
}
