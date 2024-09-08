---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
      },
    },
  },
}
