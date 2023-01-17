return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  event = "BufReadPost",
  keys = {
    { "<c-space>", desc = "Increment selection" },
    { "<c-bs>", desc = "Shrink selection" },
  },
  dependencies = {
    "p00f/nvim-ts-rainbow",
    "nvim-treesitter/playground",
  },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    rainbow = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = false,
        node_decremental = "<c-bs>",
      },
    },
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "go",
      "gomod",
      "gowork",
      "javascript",
      "latex",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "rust",
      "typescript",
      "vim",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}
