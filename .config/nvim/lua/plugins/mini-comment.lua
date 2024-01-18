return {
  {
    "nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },

  {
    "echasnovski/mini.comment",
    dependencies = { "nvim-ts-context-commentstring" },
    keys = {
      "gcc",
      { "gc", mode = { "n", "v" } },
      { "<c-/>", "gcc", mode = "n", remap = true },
      { "<c-/>", "gc", mode = "v", remap = true },
    },
    opts = {
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
        ignore_blank_line = true,
      },
    },
  },
}
