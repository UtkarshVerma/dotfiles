hi VimwikiDelText term=strikethrough cterm=strikethrough gui=strikethrough
set wrap linebreak
set colorcolumn= signcolumn=no
set showtabline=0

" Move within wrapped lines
nnoremap <expr> <up> (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> <down> (v:count == 0 ? 'gj' : 'j')
