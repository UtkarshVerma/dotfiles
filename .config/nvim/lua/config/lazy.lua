local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "plugins" },
  },
  change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = false, -- always use the latest git commit
  },
  ui = {
    border = "rounded",
  },
  install = { colorscheme = { "molokai", "catppuccin" } },
})
