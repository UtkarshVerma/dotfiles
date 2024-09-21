local config = require("config")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.c_syntax_for_h = true

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
  foldlevel = 99, -- Keep all folds open
  foldlevelstart = 99, -- Keep all folds open
  foldenable = true,
  fillchars = {
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = " ", -- alternatives: ‾ ─
    fold = " ",
    foldopen = "",
    foldclose = "",
    vert = "┃", -- Used for window separator.
  },
  shiftwidth = 4, -- Size of an indent
  swapfile = false,
  tabstop = 4, -- Number of spaces tabs count for
  title = true,
  titlestring = "%(%t - %)%(%{substitute(getcwd(), '^.*/', '', '')} - %)%{v:progname}",
  titlelen = 50,
  undodir = "/tmp/nvim-undodir", -- Preserve undo history per reboot

  clipboard = "unnamedplus", -- Sync with system clipboard
  completeopt = { "menuone", "noselect", "preview" },
  conceallevel = 2, -- Hide concealed text.
  confirm = true, -- Confirm to save changes before exiting modified buffer
  cursorline = true, -- Enable highlighting of the current line
  expandtab = true, -- Use spaces instead of tabs
  -- formatoptions = "jqlnt", -- tcqj
  grepformat = "%f:%l:%c:%m",
  grepprg = "rg, --vimgrep",
  ignorecase = true, -- Ignore case
  inccommand = "nosplit", -- preview incremental substitute
  laststatus = 2, -- Always show statusline.
  list = true, -- Show some invisible characters (tabs...
  mouse = "a", -- Enable mouse mode
  number = true, -- Print line number
  pumblend = 10, -- Popup blend
  pumheight = 10, -- Maximum number of entries in a popup
  relativenumber = true, -- Relative line numbers
  scrolloff = 4, -- Lines of context
  sessionoptions = {
    "blank",
    "buffers",
    "curdir",
    "globals",
    "help",
    "localoptions",
    "skiprtp",
    "tabpages",
    "terminal",
    "winpos",
    "winsize",
  },
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

for k, v in pairs(options) do
  vim.opt[k] = v
end
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })
vim.opt.formatoptions:remove({ "c", "r", "o" })

vim.filetype.add({
  filename = {
    wscript = "python",
    ["hugo.work"] = "gowork",
    Kraftfile = "yaml",
  },
  pattern = {
    ["${XDG_CONFIG_HOME}/hypr/.*.conf"] = "hyprlang",
  },
  extension = {
    dto = "devicetree",
    def = "c",
    mdx = "markdown",
    sub = "spice",
    cl = "c",
  },
})

vim.diagnostic.config({
  underline = true,
  update_in_insert = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  virtual_lines = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    source = "if_many",
  },
})

for name, icon in pairs(config.icons.diagnostics) do
  name = "DiagnosticSign" .. name
  vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
end
