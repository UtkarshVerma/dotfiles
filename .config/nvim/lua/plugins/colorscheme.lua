return {
  { "folke/tokyonight.nvim", enabled = false },
  {
    "UtkarshVerma/molokai.nvim",
    dir = "~/git/molokai.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "molokai" } },
}
