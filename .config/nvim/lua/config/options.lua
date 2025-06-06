local config = require("config")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = {
  foldenable = true, -- Enable folds
  foldlevel = 99, -- Start with all folds open
  foldmethod = "expr",
  foldexpr = "v:lua.vim.treesitter.foldexpr()", -- Use treesitter for folding
  foldtext = "", -- Text shown when fold is closed
  foldcolumn = "0", -- Hide fold column

  fillchars = {
    foldopen = "",
    foldclose = "",
    foldsep = " ",
    fold = " ",
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = " ", -- alternatives: ‾ ─
    vert = "┃", -- Used for window separator.
  },

  breakindent = true, -- Indent wrapped lines
  colorcolumn = "80",
  guifont = "monospace",

  shiftwidth = 4, -- Size of an indent
  swapfile = false,
  tabstop = 4, -- Number of spaces tabs count for
  title = true,
  titlestring = "%(%t - %)%(%{substitute(getcwd(), '^.*/', '', '')} - %)%{v:progname}",
  titlelen = 50,

  completeopt = { "menuone", "noselect", "preview" },
  conceallevel = 2, -- Hide concealed text.
  confirm = true, -- Confirm to save changes before exiting modified buffer

  cursorline = true, -- Enable current line highlight

  expandtab = true, -- Use spaces instead of tabs
  -- formatoptions = "jqlnt", -- tcqj

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term.
  ignorecase = true,
  smartcase = true,

  inccommand = "split", -- Preview substitutions live
  laststatus = 2, -- Always show statusline.

  -- Sets how neovim will display certain whitespace characters in the editor.
  list = true,
  listchars = {
    tab = "» ",
    eol = "↴",
    nbsp = "␣",
    trail = "·",
  },

  mouse = "a", -- Enable mouse mode

  number = true, -- Line numbers
  relativenumber = true, -- Relative line numbers

  pumblend = 10, -- Popup blend
  pumheight = 10, -- Maximum number of entries in a popup
  scrolloff = 10, -- Lines of context
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
  signcolumn = "yes", -- Always show the signcolumn and avoid layout shift.
  smartindent = true, -- Insert indents automatically
  spelllang = { "en_gb" },

  splitbelow = true, -- Put new windows below current
  splitright = true, -- Put new windows right of current

  termguicolors = true, -- True color support
  undofile = true, -- Save undo history
  undolevels = 10000,

  updatetime = 200, -- Reduce CursorHold trigger duration
  timeoutlen = 300, -- Decrease mapped sequence wait time

  wildmode = "longest:full,full", -- Command-line completion mode
  winminwidth = 5, -- Minimum window width
  wrap = false, -- Disable line wrap

  splitkeep = "screen",
  virtualedit = "block", -- Allow cursor to move where there is no text in visual block mode

  -- Only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically.
  clipboard = vim.env.SSH_TTY and "" or "unnamedplus", -- Sync with system clipboard

  smoothscroll = true,
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
    ["${XDG_CONFIG_HOME}/redshift/redshift.conf"] = "confini",
  },
  extension = {
    cl = "c",
    def = "c",
    dto = "devicetree",
    mdx = "markdown",
    overlay = "devicetree",
    rasi = "rasi",
    sub = "spice",
    tf = "terraform",
    v = "verilog",
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
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    source = true,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = config.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = config.icons.diagnostics.Warn,
      [vim.diagnostic.severity.INFO] = config.icons.diagnostics.Info,
      [vim.diagnostic.severity.HINT] = config.icons.diagnostics.Hint,
    },
  },
})
