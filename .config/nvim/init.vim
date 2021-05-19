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
	Plug 'lervag/vimtex'
	Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

	Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
	Plug 'vimwiki/vimwiki'
	Plug 'vim-pandoc/vim-pandoc-syntax'

	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	Plug 'kana/vim-operator-user'
	Plug 'rhysd/vim-clang-format'
	Plug 'jackguo380/vim-lsp-cxx-highlight'

	Plug 'tomasr/molokai'

	Plug 'vim-syntastic/syntastic'
	Plug 'SirVer/ultisnips'
	Plug 'preservim/nerdcommenter'
	Plug 'vim-airline/vim-airline'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'kien/ctrlp.vim'
	Plug 'scrooloose/nerdtree'
call plug#end()

set encoding=utf-8
set clipboard=unnamedplus
set nu rnu
filetype plugin indent on
let python_highlight_all=1
syntax on

" Compile and run
autocmd FileType c nnoremap <F4> :w <CR> :!gcc % -o %< && ./%< <CR>
autocmd FileType c inoremap <F4> <Esc> :w <CR> :!gcc % -o %< && ./%< <CR>

" Use vim-pandoc-syntax for vimwiki
augroup pandoc_syntax
  autocmd! FileType vimwiki set syntax=markdown.pandoc
augroup END

" clang-format settings
autocmd FileType c,cpp ClangFormatAutoEnable
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
nmap <Leader>C :ClangFormatAutoToggle<CR>

" Syntastic settings
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" VimTeX settings
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_view_general_options_latexmk = '-reuse-instance -e "$pdflatex=q/pdflatex %O -shell-escape %S/"'

" coc.nvim settings
let g:coc_global_extensions = [
	\ 'coc-vimtex',
	\ 'coc-snippets',
	\ 'coc-python',
	\ 'coc-pyright',
	\ 'coc-json',
	\ 'coc-sh',
	\ 'coc-yaml',
	\ 'coc-vimlsp',
	\]

nnoremap <leader>rn <Plug>(coc-rename)
" TextEdit might fail if hidden is not set.
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
	autocmd!
	" Setup formatexpr specified filetype(s).
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder.
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
	nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
	inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
	vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
	vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" Vim Airline settings
let g:airline_powerline_fonts = 1
let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'

" NERDTree settings
let NERDTreeIgnore = ['\.pyc$', '\~$']

" VimWiki settings
let g:vimwiki_list = [{'path': '~/.local/share/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" LaTeX conceal settings
let g:tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
let g:tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
let g:tex_conceal="abdgm"
let g:vim_markdown_math = 1
set conceallevel=2

" Colorscheme
colorscheme molokai
"let g:molokai_original = 1
hi Normal ctermbg=none guibg=none
hi SignColumn ctermbg=none ctermfg=59
hi Visual ctermbg=black
hi Statement cterm=none
hi LineNr ctermbg=none ctermfg=239
hi GitGutterAdd ctermfg=118 ctermbg=none
hi GitGutterChange ctermfg=208 ctermbg=none
hi GitGutterDelete ctermfg=161 ctermbg=none cterm=bold
hi GitGutterChangeDelete ctermfg=219 ctermbg=none
hi clear Conceal

" Split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Code folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" Markdown stuff
augroup Markdown
	autocmd!
	autocmd FileType markdown set wrap
augroup END

" -------------------------------------------------------
" Gentoo Specific Stuff
" -------------------------------------------------------
" Recompile dwmblocks on modifying config.h
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }

