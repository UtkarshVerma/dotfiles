---@alias plugins.cmp.config cmp.ConfigSchema

---@type LazyPluginSpec[]
return {
  {
    "hrsh7th/nvim-cmp",
    ---@diagnostic disable-next-line: assign-type-mismatch
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    opts = function(_, _)
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()

      ---@type plugins.cmp.config
      return {
        preselect = cmp.PreselectMode.None,
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menuone,noselect,preview",
        },
        mapping = cmp.mapping.preset.insert({
          ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<s-tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<cr>"] = cmp.mapping({
            i = function(fallback)
              if cmp.visible() and cmp.get_active_entry() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
              else
                fallback()
              end
            end,
            s = cmp.mapping.confirm({ select = true }),
            c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          }),

          ["<c-b>"] = cmp.mapping.scroll_docs(-4),
          ["<c-f>"] = cmp.mapping.scroll_docs(4),
          ["<c-e>"] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = "luasnip", group_index = 1 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "emoji", group_index = 2 },
          { name = "buffer", group_index = 2 },
          { name = "path", group_index = 2 },
        }),
        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          fields = { "kind", "abbr", "menu" },

          format = function(entry, item)
            local icons = require("config").icons.kinds
            item.kind = icons[item.kind]
            local sources = {
              nvim_lsp = "LSP",
              luasnip = "Snippet",
              buffer = "Buffer",
              path = "Path",
            }
            item.menu = sources[entry.source.name]
            return item
          end,
        },
        experimental = {
          ghost_text = true,
          hl_group = "Comment",
        },
        sorting = defaults.sorting,
      }
    end,
    config = function(_, opts)
      for _, source in ipairs(opts.sources) do
        source.group_index = source.group_index or 1
      end

      local cmp = require("cmp")

      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline({
          ["<cr>"] = cmp.mapping({
            c = cmp.mapping.confirm({ select = false }),
          }),
        }),

        sources = {
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline({
          ["<cr>"] = cmp.mapping({
            c = cmp.mapping.confirm({ select = false }),
          }),
        }),
        sources = cmp.config.sources({
          { name = "path" },
          { name = "cmdline" },
        }),
      })

      cmp.setup(opts)
    end,
  },
}
