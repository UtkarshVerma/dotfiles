---@module "lazy.types"

-- This filetype mapping is required for docker-compose-language-service.
vim.filetype.add({
  filename = {
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
})

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dockerfile",
        "yaml",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        dockerls = {},
      },
    },
  },

  {
    "nvim-lint",
    ---@type plugins.lint.config
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
}
