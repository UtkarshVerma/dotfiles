---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "haskell",
      },
    },
  },

  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6", -- Recommended.
    lazy = false, -- This plugin is already lazy.
    keys = {
      {
        "<leader>hs",
        function()
          require("haskell-tools").hoogle.hoogle_signature()
        end,
        desc = "Hoogle search",
      },

      {
        "<leader>he",
        function()
          require("haskell-tools").lsp.buf_eval_all()
        end,
        desc = "Evaluale all code snippets",
      },

      {
        "<leader>hr",
        function()
          require("haskell-tools").repl.toggle()
        end,
        desc = "Toggle REPL (Package)",
      },

      {
        "<leader>hr",
        function()
          require("haskell-tools").repl.toggle(vim.api.nvim_buf_get_name(0))
        end,
        desc = "Toggle REPL (Buffer)",
      },
    },
  },
}
