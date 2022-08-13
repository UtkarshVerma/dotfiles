vim.cmd([[
    fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfun

    augroup main
        autocmd!
        autocmd BufWritePre * :call TrimWhitespace()
    augroup END

    " Fix for `nnn`'s restorepreview patch
    autocmd VimEnter * :silent exec "!kill -s WINCH $PPID"

    " Restore blinking cursor on exit
    autocmd VimLeave,VimSuspend * set guicursor=a:ver2-blinkon1
]])
