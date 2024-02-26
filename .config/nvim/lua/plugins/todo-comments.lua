---@type LazyPluginSpec[]
return {
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    dependencies = { "trouble.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
      { "]t", "<cmd>lua require('todo-comments').jump_next()<cr>", desc = "Next todo comment" },
      { "[t", "<cmd>lua require('todo-comments').jump_prev()<cr>", desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/fix/fixme (trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/fix/fixme" },
    },
    opts = {},
  },
}
