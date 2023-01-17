return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "echasnovski/mini.comment",
    dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    keys = function(plugin, _)
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return {
        { opts.mappings.comment, mode = { "n", "v" } },
        opts.mappings.comment_line,
        { "<c-/>", mode = { "n", "v" } },
      }
    end,
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
