return {
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin", enabled = false },
  {
    "UtkarshVerma/molokai.nvim",
    dir = "~/github/molokai.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai",
    },
  },
}
