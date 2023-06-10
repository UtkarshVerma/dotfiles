return {
  {
    "L3MON4D3/LuaSnip",
    keys = {}, -- in favour of supertab
    config = function()
      -- Forget previous snippets when modes are changed. This is to avoid unexpected
      -- jumps when pressing Tab.
      local luasnip = require("luasnip")

      vim.api.nvim_create_autocmd("ModeChanged", {
        group = vim.api.nvim_create_augroup("UnlinkLuaSnipSnippetOnModeChange", {
          clear = true,
        }),
        pattern = { "s:n", "i:*" },
        desc = "Forget the current snippet when leaving the insert mode",
        callback = function(evt)
          -- If we have n active nodes, n - 1 will still remain after a `unlink_current()` call.
          -- We unlink all of them by wrapping the calls in a loop.
          while true do
            if luasnip.session and luasnip.session.current_nodes[evt.buf] and not luasnip.session.jump_active then
              luasnip.unlink_current()
            else
              break
            end
          end
        end,
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      return vim.tbl_deep_extend("force", opts, {
        mapping = {
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
        },
      })
    end,
  },
}
