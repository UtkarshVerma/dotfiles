-- Restore default cursor on exit
vim.api.nvim_create_autocmd(
  { "VimLeave", "VimSuspend" },
  { command = "set guicursor= | call chansend(v:stderr, '\x1b[ q')" }
)

-- coreboot development settings
local coreboot_dir = vim.fn.expand("~") .. "/gsoc/coreboot/coreboot/"
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { coreboot_dir .. "*", coreboot_dir .. "*" },
  callback = function(_)
    vim.o.tabstop = 8
    vim.o.shiftwidth = 8
    vim.o.expandtab = false
    return true
  end,
})
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { coreboot_dir .. "*.c", coreboot_dir .. "*.h" },
  callback = function(_)
    vim.o.colorcolumn = "97"
    vim.opt_local.commentstring = "/*%s*/"
    return true
  end,
})
