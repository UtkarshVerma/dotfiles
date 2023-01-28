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
          "rust",
          "typescript",
          "vim",
          "yaml",
        },
        rainbow = { enable = true },
        playground = { enable = true },
      })
    end,
  },
}
