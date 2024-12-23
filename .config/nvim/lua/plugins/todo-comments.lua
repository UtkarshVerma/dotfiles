---@type LazyPluginSpec[]
return {
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoQuickFix", "TodoTelescope" },
    keys = {
      -- stylua: ignore start
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      -- stylua: ignore end

      { "<leader>xt", "<cmd>TodoQuickFix<cr>", desc = "Todo" },
      { "<leader>xT", "<cmd>TodoQuickFix keywords=TODO,FIX,FIXME<cr>", desc = "Todo/fix/fixme" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/fix/fixme" },
    },
    opts = {},
  },
}
