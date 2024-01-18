return {
  {
    "kevinhwang91/nvim-ufo",
    event = "LazyFile",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter",
    },
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
      ---@param filetype string
      ---@param buftype string
      provider_selector = function(_, filetype, buftype)
        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or { "treesitter", "indent" } -- if file opened, try to use treesitter if available
      end,
    },
  },
}
