-- -- nvim-telescope/telescope-dap.nvim
-- require("telescope").load_extension("dap")({ "<leader>ds", ":Telescope dap frames<CR>" }),

return {
  -- {
  --   "nvim-telescope/telescope-dap.nvim",
  --   dependencies = { "nvim-telescope/telescope.nvim" },
  --   opts = {},
  -- },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = {
        "bash-debug-adapter",
        "cpptools",
        "debugpy",
        "delve",
      },
    },
  },
}
