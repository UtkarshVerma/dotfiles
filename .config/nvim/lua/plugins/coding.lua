return {
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
        completion = {
          completeopt = "menuone,noselect",
        },
        window = {
          documentation = {
            winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder",
          },
        },
        mapping = cmp.mapping.preset.insert({
          ["<c-d>"] = cmp.mapping.scroll_docs(-4),
          ["<c-f>"] = cmp.mapping.scroll_docs(4),
          ["<c-space>"] = cmp.mapping.complete(),
          ["<cr>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
            -- they way you will only jump inside the snippet region
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
        }),
      })
    end,
  },
  {
    "echasnovski/mini.move",
    keys = function(plugin, _)
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return {
        opts.mappings.left,
        opts.mappings.right,
        opts.mappings.down,
        opts.mappings.up,

        { opts.mappings.line_left, mode = "v" },
        { opts.mappings.line_right, mode = "v" },
        { opts.mappings.line_down, mode = "v" },
        { opts.mappings.line_up, mode = "v" },
      }
    end,
    opts = {
      mappings = {
        -- Visual selection mappings
        left = "<a-left>",
        right = "<a-right>",
        down = "<a-down>",
        up = "<a-up>",

        -- Normal mode mappings
        line_left = "<a-left>",
        line_right = "<a-right>",
        line_down = "<a-down>",
        line_up = "<a-up>",
      },
    },
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    event = "BufReadPre",
    config = true,
  },
  { "p00f/nvim-ts-rainbow" },
  { "echasnovski/mini.pairs", enabled = false },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
      -- change default fast_wrap
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)
      require("nvim-treesitter.configs").setup({ autopairs = { enable = true } })

      local rule = require("nvim-autopairs.rule")
      local ts_conds = require("nvim-autopairs.ts-conds")

      -- press % => %% only while inside a comment or string
      autopairs.add_rules({
        rule("%", "%", "lua"):with_pair(ts_conds.is_ts_node({ "string", "comment" })),
        rule("$", "$", "lua"):with_pair(ts_conds.is_not_ts_node({ "function" })),
      })

      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "echasnovski/mini.comment",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      mappings = {
        comment = "gc",
        comment_line = "gcc",
        textobject = "gc",
      },
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring({})
        end,
      },
    },
    config = function(_, opts)
      vim.keymap.set("n", "<c-/>", opts.mappings.comment_line, { remap = true, desc = "Comment line" })
      vim.keymap.set("v", "<c-/>", opts.mappings.comment, { remap = true, desc = "Comment selection" })
      require("mini.comment").setup(opts)
    end,
  },
}
