vim.cmd([[
    " Restore blinking cursor on exit
    autocmd VimLeave,VimSuspend * set guicursor=a:ver2-blinkon1
]])
