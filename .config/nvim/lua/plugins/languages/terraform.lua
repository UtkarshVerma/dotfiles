local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "terraform",
        "hcl",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        terraformls = {},
      },
    },
  },

  {
    "ANGkeith/telescope-terraform-doc.nvim",
    ft = { "terraform", "hcl" },
    config = function()
      util.plugin.on_load("telescope.nvim", function()
        require("telescope").load_extension("terraform_doc")
      end)
    end,
  },

  {
    "cappyzawa/telescope-terraform.nvim",
    ft = { "terraform", "hcl" },
    config = function()
      util.plugin.on_load("telescope.nvim", function()
        require("telescope").load_extension("terraform")
      end)
    end,
  },

  {
    "nvim-lint",
    opts = {
      linters_by_ft = {
        terraform = { "tflint", "terraform_validate" },
        tf = { "tflint", "terraform_validate" },
      },
    },
  },

  {
    "conform.nvim",
    opts = {
      formatters_by_ft = {
        hcl = { "packer_fmt" },
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
      },
    },
  },
}
