return {
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    ft = "norg",
    keys = {
      { "<leader>nd", "<cmd>Neorg workspace<cr>", desc = "Default workspace" },
      { "<leader>ni", "<cmd>Neorg index<cr>", desc = "Index" },
      { "<leader>nr", "<cmd>Neorg return<cr>", desc = "Close buffers" },
    },
    build = ":Neorg sync-parsers",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "which-key.nvim",
        opts = function(_, opts)
          opts.defaults["<leader>n"] = { name = "+neorg" }
        end,
      },
    },
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {},
        ["core.summary"] = {},
        ["core.esupports.metagen"] = {
          config = {
            type = "empty",
          },
        },
        ["core.dirman"] = {
          config = {
            workspaces = {
              main = "~/notes/main",
              gsi = "~/notes/gsi",
              gsoc = "~/notes/gsoc",
            },
            default_workspace = "main",
          },
        },
      },
    },
  },
}
