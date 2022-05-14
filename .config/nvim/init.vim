" Automate Plug installation, if not present
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
	silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
		\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

call plug#begin()
    " My plugins
    Plug 'ferrine/md-img-paste.vim'
    Plug 'AlphaTechnolog/pywal.nvim', { 'as': 'pywal' }
    Plug 'vimwiki/vimwiki'

    " Completions
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    " Snippets
    Plug 'saadparwaiz1/cmp_luasnip'
    Plug 'rafamadriz/friendly-snippets'
    Plug 'L3MON4D3/LuaSnip'

    " LSP
    Plug 'neovim/nvim-lspconfig'
    Plug 'williamboman/nvim-lsp-installer'

    " Telescope
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-media-files.nvim'

    " Treesitter
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " Autopairs
    Plug 'windwp/nvim-autopairs'

    " Comments
    Plug 'numToStr/Comment.nvim'

    " Git
    Plug 'lewis6991/gitsigns.nvim'

    " Nvim Tree
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'

    " Bufferline
    Plug 'akinsho/bufferline.nvim'
    Plug 'moll/vim-bbye'

    " External formatting and linting
    " Plug 'jose-elias-alvarez/null-ls.nvim'

    " Terminal
    Plug 'akinsho/toggleterm.nvim'
call plug#end()

colorscheme molokai
highlight Normal guibg=None
