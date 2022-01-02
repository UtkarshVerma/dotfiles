" Automate Plug installation, if not present
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
	silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs 
		\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

call plug#begin()
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'tpope/vim-commentary'

    Plug 'neovim/nvim-lspconfig'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'kyazdani42/nvim-web-devicons'

    Plug 'vimwiki/vimwiki'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/limelight.vim'

	Plug 'vim-airline/vim-airline'
call plug#end()

colorscheme molokai
