-- Auto-install Packer
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path
    })
    print("Installing Packer. Close and re-open Neovim")
    vim.cmd("packadd packer.nvim")
end

-- Autocommand to reload Neovim whenever plugins/init.lua is updated
vim.cmd([[
    augroup packer_config
        autocmd!
        autocmd BufWritePost */nvim/lua/plugins/packer.lua source <afile> | PackerSync
    augroup end
]])

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
    use "wbthomason/packer.nvim" -- Have Packer manage itself

    -- My plugins
    use "lewis6991/impatient.nvim"
    use "dinhhuy258/git.nvim"
    use "vimwiki/vimwiki"
    --"Plug "ferrine/md-img-paste.vim"

    -- Treesitter and companion plugins
    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use "nvim-treesitter/playground"
    use "p00f/nvim-ts-rainbow" -- Rainbow brackets
    use "windwp/nvim-autopairs"
    use "windwp/nvim-ts-autotag"
    use "numToStr/Comment.nvim"

    use "lewis6991/gitsigns.nvim"
    use "akinsho/bufferline.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "nvim-lualine/lualine.nvim"
    use "lukas-reineke/indent-blankline.nvim"
    use "goolord/alpha-nvim"
    use "UtkarshVerma/molokai.nvim"
    use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }
    -- use "folke/which-key.nvim"

    -- Telescope
    use { "nvim-telescope/telescope.nvim", requires = "nvim-lua/plenary.nvim" }
    use "nvim-telescope/telescope-file-browser.nvim"

    -- LSP
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use "glepnir/lspsaga.nvim"
    use "jose-elias-alvarez/null-ls.nvim"

    -- Completions
    use "L3MON4D3/LuaSnip"
    use "onsails/lspkind-nvim"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/nvim-cmp"

    -- Automatically set up config after cloning Packer
    if packer_bootstrap then
        packer.sync()
    end
end)
