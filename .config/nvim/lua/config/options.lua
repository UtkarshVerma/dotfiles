local options = {
  backup = false,
  breakindent = true, -- Enable break indent
  colorcolumn = "80",
  errorbells = false,
  guifont = "monospace",
  listchars = "tab:» ,eol:↴,nbsp:␣,trail:·",
  pumblend = 0, -- Popup blend
  shiftwidth = 4, -- Size of an indent
  swapfile = false,
  tabstop = 4, -- Number of spaces tabs count for
  title = true,
  undodir = "/tmp/nvim-undodir", -- Preserve undo history per reboot
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
