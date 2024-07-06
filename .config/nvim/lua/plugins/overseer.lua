---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      defaults = {
        ["<leader>o"] = { name = "+overseer" },
      },
    },
  },
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Run" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Quick action" },
    },
    ---@type overseer.Config
    opts = {
      templates = {
        "builtin",
        "user.run_script",
      },
    },
  },
}
