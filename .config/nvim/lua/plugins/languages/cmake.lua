---@module "lazy.types"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "cmake",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        neocmake = {
          init_options = {
            single_file_support = true,
            format = { enable = false }, -- gersemi is better.
            lint = { enable = false }, -- external cmake_lint integrates better.
            semantic_tokens = false,
          },
        },
      },
    },
  },

  {
    "nvim-lint",
    ---@type plugins.lint.config
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
      },
    },
  },

  {
    "conform.nvim",
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        cmake = { "gersemi" },
      },
    },
  },
}
