-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazy_path,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazy_path)

local config = require("config")
config.init()

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.languages" },
    { import = "plugins.extras.writing" },
    { import = "plugins.extras.oil" },
  },
  change_detection = { enabled = false },
  defaults = {
    lazy = true,
    version = "*",
  },
  install = { colorscheme = { "monokai-pro" } },
  performance = {
    rtp = {
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

config.setup()
