set nocompatible
filetype off

" Automate Plug installation, if not present
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
	silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs 
		\ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

call plug#begin()
	Plug 'vim-pandoc/vim-pandoc-syntax'
	Plug 'junegunn/vader.vim'

	Plug 'dense-analysis/ale'
	Plug 'vim-airline/vim-airline'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'kien/ctrlp.vim'
	Plug 'luukvbaal/nnn.nvim'
call plug#end()

lua << EOF
require("nnn").setup()
EOF

set encoding=utf-8
set clipboard=unnamedplus
set nu rnu
filetype plugin indent on
syntax on

" Vim Airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme = 'molokai'
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'

" nnn.nvim keybindings
tnoremap <C-A-n> <cmd>NnnExplorer<CR>
nnoremap <C-A-n> <cmd>NnnExplorer %:p:h<CR>
tnoremap <C-A-p> <cmd>NnnPicker<CR>
nnoremap <C-A-p> <cmd>NnnPicker<CR>

" Colorscheme
colorscheme molokai
hi GitGutterAdd ctermfg=118 ctermbg=none
hi GitGutterChange ctermfg=208 ctermbg=none
hi GitGutterDelete ctermfg=161 ctermbg=none cterm=bold
hi GitGutterChangeDelete ctermfg=219 ctermbg=none

" Markdown stuff
augroup Markdown
	autocmd!
	autocmd FileType markdown set wrap
augroup END

" Workaround for `nnn`
autocmd VimEnter * :silent exec "!kill -s WINCH $PPID"

" Restore blinking cursor on exit
au VimLeave,VimSuspend * set guicursor=a:ver2-blinkon1
