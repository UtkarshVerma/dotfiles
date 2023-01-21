-- Restore default cursor on exit
vim.api.nvim_create_autocmd(
  { "VimLeave", "VimSuspend" },
  { command = "set guicursor= | call chansend(v:stderr, '\x1b[ q')" }
)
