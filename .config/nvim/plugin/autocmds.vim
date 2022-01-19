fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup main
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
