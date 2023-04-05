return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = "nvim-treesitter/playground",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        ensure_installed = {
          "arduino",
          "bash",
          "c",
          "cpp",
          "devicetree",
          "dockerfile",
          "go",
          "gomod",
          "gowork",
          "help",
          "html",
          "javascript",
          "json",
          "latex",
          "lua",
          "markdown",
          "markdown_inline",
          "python",
          "regex",
          "rst",
          "rust",
          "typescript",
          "vim",
          "yaml",
        },
        playground = { enable = true },
      })
    end,
  },
}
