vim.cmd([[
    " Highlight on yank
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()

    " Restore blinking cursor on exit
    autocmd VimLeave,VimSuspend * set guicursor=a:ver2-blinkon1
]])
