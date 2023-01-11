vim.cmd([[
    " Restore blinking cursor on exit
    autocmd VimLeave,VimSuspend * set guicursor= | call chansend(v:stderr, "\x1b[ q")
]])
