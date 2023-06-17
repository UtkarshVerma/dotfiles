local function has_words_before()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    dependencies = {
      {
        "nvim-lspconfig",
        opts = function(_, opts)
          return vim.tbl_deep_extend("force", opts, {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "cmp-nvim-lsp",
      "LuaSnip",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

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

      return {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menuone,noselect,preview",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
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
          ["<esc>"] = cmp.mapping(function(fallback)
            luasnip.unlink_current()
            fallback()
          end),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "emoji" },
          { name = "buffer", keyword_length = 5 },
          { name = "path" },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },

          format = function(entry, item)
            local icons = require("config").icons.kinds
            item.kind = icons[item.kind]
            local sources = {
              nvim_lsp = "LSP",
              nvim_lua = "Lua",
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
        },
      }
    end,
  },
}
