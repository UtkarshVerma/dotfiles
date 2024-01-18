return {
  {
    "luukvbaal/statuscol.nvim",
    event = "LazyFile",
    opts = function(_, opts)
      local builtin = require("statuscol.builtin")

      return {
        relculright = false,
        ft_ignore = {
          "neo-tree",
        },
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
