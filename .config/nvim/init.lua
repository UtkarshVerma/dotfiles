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

require("config").setup()
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.extras.copilot" },
    { import = "plugins.extras.flash" },
  },
  change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = "*",
  },
  install = { colorscheme = { "monokai-pro", "catppuccin", "molokai" } },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
