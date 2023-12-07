local icons = require("config").icons

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "LazyFile",
    opts = function(_, opts)
      local excluded_filetypes = vim.list_extend((opts.exclude or {}).filetypes or {}, {
        "help",
        "lazy",
        "lazyterm",
      })

      return {
        exclude = {
          filetypes = excluded_filetypes,
        },
        indent = {
          char = icons.indent.inactive,
          tab_char = icons.indent.inactive,
          priority = 11,
        },
      }
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
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
    event = "LazyFile",
    opts = function(_, opts)
      local builtin = require("statuscol.builtin")
      local excluded_filetypes = opts.ft_ignore or {}

      return {
        relculright = false,
        ft_ignore = excluded_filetypes,
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
