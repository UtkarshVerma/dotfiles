vim.cmd([[
    " Fix for `nnn`'s restorepreview patch
    autocmd VimEnter * :silent exec "!kill -s WINCH $PPID"

    " Restore blinking cursor on exit
    autocmd VimLeave,VimSuspend * set guicursor=a:ver2-blinkon1
]])
