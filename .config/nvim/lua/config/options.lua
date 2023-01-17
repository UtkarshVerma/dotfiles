-- Map leader to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

local options = {
  tabstop = 4, -- Number of spaces tabs count for
  shiftwidth = 4, -- Size of an indent
  expandtab = true, -- Expand tabs to spaces
  autowrite = true, -- enable auto write
  clipboard = "unnamedplus", -- sync with system clipboard
  cmdheight = 1,
  conceallevel = 3, -- Hide * markup for bold and italic
  confirm = true, -- confirm to save changes before exiting modified buffer
  cursorline = true, -- Enable highlighting of the current line
  formatoptions = "jcroqlnt", -- tcqj
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg --vimgrep",
  hidden = true, -- Enable modified buffers in background
  ignorecase = true, -- Ignore case
  inccommand = "nosplit", -- preview incremental substitute
  joinspaces = false, -- No double spaces with join after a dot
  laststatus = 0,
  list = true, -- Show invisible characters
  listchars = "tab:» ,eol:↴,nbsp:␣,trail:·",
  mouse = "a", -- enable mouse mode
  number = true, -- Print line number
  pumblend = 0, -- Popup blend
  pumheight = 10, -- Maximum number of entries in a popup
  relativenumber = true, -- Relative line numbers
  scrolloff = 4, -- Lines of context
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
  shiftround = true, -- Round indent
  showmode = false, -- dont show mode since we have a statusline
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
  undodir = "/tmp/nvim-undodir", -- Preserve undo history per reboot
  undolevels = 10000,
  updatetime = 200, -- save swap file and trigger CursorHold
  wildmode = "longest:full,full", -- Command-line completion mode
  winminwidth = 5, -- minimum window width
  wrap = false, -- Disable line wrap
  hlsearch = false, -- Don't highlight matches for previous search
  breakindent = true, -- Enable break indent
  backup = false,
  swapfile = false,
  errorbells = false,
  title = true,
  colorcolumn = "80",
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.o.shortmess = "filnxtToOFWIcC"
end
