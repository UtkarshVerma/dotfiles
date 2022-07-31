-- Auto-install Packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
      "git", "clone", "--depth", "1",
      "https://github.com/wbthomason/packer.nvim", install_path
  })
  print "Installing Packer. Close and re-open Neovim"
  vim.cmd "packadd packer.nvim"
end

-- Autocommand to reload Neovim whenever plugins/init.lua is updated
vim.cmd [[
    augroup packer_config
        autocmd!
        autocmd BufWritePost */nvim/lua/plugins/init.lua source <afile> | PackerSync
    augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have Packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end
    }
})

-- Plugins
packer.startup(function(use)
    use "wbthomason/packer.nvim"    -- Have Packer manage itself

    -- Note-taking
    use "vimwiki/vimwiki"
    --" My plugins
  --"Plug "ferrine/md-img-paste.vim"

  --" Completions
  --Plug "hrsh7th/nvim-cmp"
  --Plug "hrsh7th/cmp-buffer"
  --Plug "hrsh7th/cmp-path"
  --Plug "hrsh7th/cmp-nvim-lua"
  --Plug "hrsh7th/cmp-nvim-lsp"

  --" Snippets
  --" Plug "saadparwaiz1/cmp_luasnip"
  --" Plug "rafamadriz/friendly-snippets"
  --" Plug "L3MON4D3/LuaSnip"
  --"
  --" " LSP
  --" Plug "neovim/nvim-lspconfig"
  --" Plug "williamboman/nvim-lsp-installer"
  --"
  --" " Telescope
  --" Plug "nvim-lua/popup.nvim"
  --" Plug "nvim-lua/plenary.nvim"
  --" Plug "nvim-telescope/telescope.nvim"
  --" Plug "nvim-telescope/telescope-media-files.nvim"

    -- Treesitter and companion plugins
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    } 
    use "p00f/nvim-ts-rainbow"      -- Rainbow brackets
    use "windwp/nvim-autopairs"
    use "numToStr/Comment.nvim"

    use "lewis6991/gitsigns.nvim"
    use "nvim-lualine/lualine.nvim"

  --" " Nvim Tree
  --" Plug "kyazdani42/nvim-web-devicons"
  --" Plug "kyazdani42/nvim-tree.lua"
  --"
  --" " Bufferline
  --" " Plug "akinsho/bufferline.nvim"
  --" " Plug "moll/vim-bbye"
  --"
  --" " External formatting and linting
  --" " Plug "jose-elias-alvarez/null-ls.nvim"
  --"
  --" " Terminal
  --" Plug "akinsho/toggleterm.nvim"

    -- Automatically set up config after cloning Packer
    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- Load plugin configs
local configs = {
    "autopairs",
    "comment",
    "gitsigns",
    "lualine",
    "treesitter"
}

for _, config in ipairs(configs) do
    require("plugins." .. config)
end
