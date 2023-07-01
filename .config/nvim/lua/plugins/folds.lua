local icons = require("config").icons

return {
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, _)
      return {
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
          priority = 25,
        },
        options = {
          border = "top",
          try_as_border = true,
        },
        symbol = icons.indent.active,
      }
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      filetype_exclude = {
        "help",
        "dashboard",
        "neo-tree",
        "norg",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
      char = icons.indent.inactive,
      context_char = icons.indent.active,
      char_priority = 20,
      use_treesitter = true,
    },
  },
  {
    "kevinhwang91/nvim-ufo",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "kevinhwang91/promise-async" },
    init = function()
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
    end,
    opts = {
      preview = {
        mappings = {
          scrollB = "<c-b>",
          scrollF = "<c-f>",
          scrollU = "<c-u>",
          scrollD = "<c-d>",
        },
      },
      open_fold_hl_timeout = 0,
      provider_selector = function(_, filetype, buftype)
        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or { "treesitter", "indent" } -- if file opened, try to use treesitter if available
      end,
    },
  },
  {
    "luukvbaal/statuscol.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, _)
      local builtin = require("statuscol.builtin")

      return {
        relculright = false,
        ft_ignore = { "neo-tree" },
        segments = {
          { text = { builtin.foldfunc }, click = "v:lua.ScFa" }, -- Fold
          { text = { "%s" }, click = "v:lua.ScSa" }, -- Sign
          {
            -- line number
            text = { " ", builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
        },
      }
    end,
  },
}
