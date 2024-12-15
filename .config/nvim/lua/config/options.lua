local config = require("config")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local options = {
  foldenable = true, -- Enable folds
  foldcolumn = "0", -- Hide fold column

  breakindent = true, -- Indent wrapped lines
  colorcolumn = "80",
  guifont = "monospace",
  fillchars = {
    eob = " ", -- suppress ~ at EndOfBuffer
    diff = "╱", -- alternatives = ⣿ ░ ─
    msgsep = " ", -- alternatives: ‾ ─
    vert = "┃", -- Used for window separator.
  },
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
  spelllang = { "en" },

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
}

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

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
    dto = "devicetree",
    overlay = "devicetree",
    def = "c",
    mdx = "markdown",
    sub = "spice",
    cl = "c",
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
