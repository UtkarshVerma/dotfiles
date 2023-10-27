vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Enable auto format
vim.g.autoformat = true

-- Root dir detection
-- Each entry can be:
-- * the name of a detector function like `lsp` or `cwd`
-- * a pattern or array of patterns like `.git` or `lua`.
-- * a function with signature `function(buf) -> string|string[]`
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

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
    foldopen = "",
    foldclose = "",
  },
  shiftwidth = 4, -- Size of an indent
  swapfile = false,
  tabstop = 4, -- Number of spaces tabs count for
  title = true,
  titlestring = "%(%t - %)%(%{substitute(getcwd(), '^.*/', '', '')} - %)NVIM",
  titlelen = 50,

  undodir = "/tmp/nvim-undodir", -- Preserve undo history per reboot

  -- autowrite = true, -- Enable auto write
  clipboard = "unnamedplus", -- Sync with system clipboard
  completeopt = { "menuone", "noselect", "preview" },
  conceallevel = 3, -- Hide * markup for bold and italic
  confirm = true, -- Confirm to save changes before exiting modified buffer
  cursorline = true, -- Enable highlighting of the current line
  expandtab = true, -- Use spaces instead of tabs
  -- formatoptions = "jqlnt", -- tcqj
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg, --vimgrep",
  ignorecase = true, -- Ignore case
  inccommand = "nosplit", -- preview incremental substitute
  laststatus = 0,
  list = true, -- Show some invisible characters (tabs...
  mouse = "a", -- Enable mouse mode
  number = true, -- Print line number
  pumblend = 10, -- Popup blend
  pumheight = 10, -- Maximum number of entries in a popup
  relativenumber = true, -- Relative line numbers
  scrolloff = 4, -- Lines of context
  sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
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
  virtualedit = "block", -- Allow cursor to move where there is no text in visual block mode
}

local opt = vim.opt
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end

-- TODO:
-- Folding
-- vim.opt.foldlevel = 99
-- vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.statuscolumn = [[%!v:lua.require'util'.ui.statuscolumn()]]
end

-- HACK: causes freezes on <= 0.9, so only enable on >= 0.10 for now
--if vim.fn.has("nvim-0.10") == 1 then
--	vim.opt.foldmethod = "expr"
--	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--else
--	vim.opt.foldmethod = "indent"
--end
--
--vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
--
---- Fix markdown indentation settings
--vim.g.markdown_recommended_style = 0

for k, v in pairs(options) do
  vim.opt[k] = v
end
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
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
