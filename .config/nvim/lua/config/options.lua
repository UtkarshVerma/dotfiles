local util = require("util")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local options = {
  backup = false,
  breakindent = true, -- Enable break indent
  colorcolumn = "80",
  errorbells = false,
  guifont = "monospace",
  listchars = {
    tab = "» ",
    eol = "↴",
    nbsp = "␣",
    trail = "·",
  },
  foldcolumn = "0", -- Don't show the foldcolumn
  foldenable = true,
  fillchars = {
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = " ", -- alternatives: ‾ ─
    fold = " ",
    foldopen = "▾",
    foldsep = " ",
    foldclose = "▸",
  },
  shiftwidth = 4, -- Size of an indent
  swapfile = false,
  tabstop = 4, -- Number of spaces tabs count for
  title = true,
  titlestring = "%(%t - %)%(%{substitute(getcwd(), '^.*/', '', '')} - %)NVIM",
  titlelen = 50,

  undodir = "/tmp/nvim-undodir", -- Preserve undo history per reboot

  autowrite = true, -- Enable auto write
  clipboard = "unnamedplus", -- Sync with system clipboard
  completeopt = { "menuone", "noselect", "preview" },
  conceallevel = 3, -- Hide * markup for bold and italic
  confirm = true, -- Confirm to save changes before exiting modified buffer
  cursorline = true, -- Enable highlighting of the current line
  expandtab = true, -- Use spaces instead of tabs
  formatoptions = "jqlnt", -- tcqj
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg, --vimgrep",
  ignorecase = true, -- Ignore case
  inccommand = "nosplit", -- preview incremental substitute
  laststatus = 0,
  list = true, -- Show some invisible characters (tabs...
  mouse = "a", -- Enable mouse mode
  number = true, -- Print line number
  pumheight = 10, -- Maximum number of entries in a popup
  relativenumber = true, -- Relative line numbers
  scrolloff = 4, -- Lines of context
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
  shiftround = true, -- Round indent
  showmode = false, -- Dont show mode since we have a statusline
  sidescrolloff = 8, -- Columns of context
  signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
  smartcase = true, -- Don't ignore case with capitals
  smartindent = true, -- Insert indents automatically
  spelllang = { "en" },
  splitbelow = true, -- Put new windows below current
  splitright = true, -- Put new windows right of current
  termguicolors = true, -- True color support
  timeoutlen = 300,
  undofile = true,
  undolevels = 10000,
  updatetime = 200, -- Save swap file and trigger CursorHold
  wildmode = "longest:full,full", -- Command-line completion mode
  winminwidth = 5, -- Minimum window width
  wrap = false, -- Disable line wrap

  splitkeep = "screen",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
vim.opt.shortmess:append({ C = true, W = true, I = true, c = true })
vim.opt.whichwrap:append({ ["<"] = true, [">"] = true }) -- Wrap movement between lines using arrow keys
vim.opt.formatoptions:remove({ "c", "r", "o" })

vim.filetype.add({
  filename = {
    wscript = "python",
  },
  extension = {
    dto = "devicetree",
    def = "c",
  },
})

vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  -- disable virtual text
  virtual_lines = false,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    source = "if_many",
    border = util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
  },
})

for name, icon in pairs(require("config").icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
