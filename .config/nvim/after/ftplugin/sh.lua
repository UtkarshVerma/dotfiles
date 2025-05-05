local opt = vim.opt_local

opt.colorcolumn = ""
opt.formatoptions:remove({ "r", "c", "o" })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = ".env",
  group = vim.api.nvim_create_augroup(".env", { clear = true }),
  desc = "Disable diagnostics for .env files.",
  callback = function(args)
    vim.diagnostic.enable(false, {
      bufnr = args.buf,
    })
  end,
})
