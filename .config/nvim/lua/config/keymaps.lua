local util = require("util")

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3

local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

---@type LazyKeysSpec[]
local keys = {
  { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Better up", expr = true },
  { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Better down", expr = true },

  { "<c-h>", "<c-w>h", desc = "Go to left window", remap = true },
  { "<c-j>", "<c-w>j", desc = "Go to lower window", remap = true },
  { "<c-k>", "<c-w>k", desc = "Go to upper window", remap = true },
  { "<c-l>", "<c-w>l", desc = "Go to right window", remap = true },

  { "<c-up>", "<cmd>resize +2<cr>", desc = "Increase window height" },
  { "<c-down>", "<cmd>resize -2<cr>", desc = "Decrease window height" },
  { "<c-left>", "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
  { "<c-right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width" },

  { "<s-h>", "<cmd>bprevious<cr>", desc = "Previous buffer" },
  { "<s-l>", "<cmd>bnext<cr>", desc = "Next buffer" },
  { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to other buffer" },

  { "<esc>", "<cmd>noh<cr><esc>", mode = { "i", "n" }, desc = "Escape and clear hlsearch" },
  { "gw", "*N", mode = { "n", "x" }, desc = "Search word under cursor" },
  { "<c-s>", "<cmd>w<cr><esc>", mode = { "i", "x", "n", "s" }, desc = "Save file" },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New File" },

  -- Saner behavior of n and N.
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  { "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next search result" },
  { "n", "'Nn'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Next search result" },
  { "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Previous search result" },
  { "N", "'nN'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Previous search result" },

  { "<leader>xl", "<cmd>lopen<cr>", desc = "Location List" },
  { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix List" },
  { "[q", vim.cmd.cprev, desc = "Previous quickfix" },
  { "]q", vim.cmd.cnext, desc = "Next quickfix" },

  -- Lazygit
  -- {esc_esc = false, ctrl_hjkl = false }) end, "<leader>gg", function() util.terminal.open({ "lazygit" }, { cwd = util.root.dir(),  desc = "Lazygit (root dir)" },
  -- {{esc_esc = false, ctrl_hjkl = false}) end, "<leader>gG", function() util.terminal.open({ "lazygit" },  desc = "Lazygit (cwd)" },

  { "<leader>ui", vim.show_pos, desc = "Inspect position" },
  { "<leader>l", "<cmd>Lazy<cr>", desc = "Lazy" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit" },

  -- stylua: ignore start
  { "<leader>ft", function() util.terminal.open(nil, { cwd = util.root.dir() }) end, desc = "Terminal (root dir)" },
  { "<leader>fT", function() util.terminal.open() end, desc = "Terminal (cwd)" },
  -- stylua: ignore end

  -- Terminal mappings
  { "<esc><esc>", "<c-\\><c-n>", mode = "t", desc = "Enter normal mode" },
  { "<C-h>", "<cmd>wincmd h<cr>", mode = "t", desc = "Go to left window" },
  { "<C-j>", "<cmd>wincmd j<cr>", mode = "t", desc = "Go to lower window" },
  { "<C-k>", "<cmd>wincmd k<cr>", mode = "t", desc = "Go to upper window" },
  { "<C-l>", "<cmd>wincmd l<cr>", mode = "t", desc = "Go to right window" },
  { "<C-/>", "<cmd>close<cr>", mode = "t", desc = "Hide terminal" },
  { "<c-_>", "<cmd>close<cr>", mode = "t", desc = "which_key_ignore" },

  -- Windows
  { "<leader>ww", "<C-W>p", desc = "Other window", remap = true },
  { "<leader>wd", "<C-W>c", desc = "Delete window", remap = true },
  { "<leader>w-", "<C-W>s", desc = "Split window below", remap = true },
  { "<leader>w|", "<C-W>v", desc = "Split window right", remap = true },
  { "<leader>-", "<C-W>s", desc = "Split window below", remap = true },
  { "<leader>|", "<C-W>v", desc = "Split window right", remap = true },

  -- Tabs
  { "<leader><tab>l", "<cmd>tablast<cr>", desc = "Last tab" },
  { "<leader><tab>f", "<cmd>tabfirst<cr>", desc = "First tab" },
  { "<leader><tab><tab>", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>]", "<cmd>tabnext<cr>", desc = "Next tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close tab" },
  { "<leader><tab>[", "<cmd>tabprevious<cr>", desc = "Previous tab" },

  -- Add undo break-points.
  { ",", ",<c-g>u", mode = "i" },
  { ".", ".<c-g>u", mode = "i" },
  { ";", ";<c-g>u", mode = "i" },

  -- stylua: ignore start
  { "<leader>uf", util.format.toggle, desc = "Toggle auto-format (global)" },
  { "<leader>uF", function() util.format.toggle("buffer") end, desc = "Toggle auto-format (buffer)" },
  { "<leader>us", function() util.toggle.option("spell") end, desc = "Toggle spelling" },
  { "<leader>uw", function() util.toggle.option("wrap") end, desc = "Toggle word wrap" },
  { "<leader>uL", function() util.toggle.option("relativenumber") end, desc = "Toggle relative line numbers" },
  { "<leader>ul", util.toggle.number, desc = "Toggle line numbers" },
  { "<leader>ud", util.toggle.diagnostics, desc = "Toggle diagnostics" },
  { "<leader>uc", function() util.toggle.option("conceallevel", { 0, conceallevel }) end, desc = "Toggle conceal" },
  -- stylua: ignore end

  -- Diagnostics
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line diagnostics" },
  { "]d", diagnostic_goto(true), desc = "Next diagnostic" },
  { "[d", diagnostic_goto(false), desc = "Previous diagnostic" },
  { "]e", diagnostic_goto(true, "ERROR"), desc = "Next error" },
  { "[e", diagnostic_goto(false, "ERROR"), desc = "Previous error" },
  { "]w", diagnostic_goto(true, "WARN"), desc = "Next warning" },
  { "[w", diagnostic_goto(false, "WARN"), desc = "Previous warning" },

  -- stylua: ignore
  { "<leader>cf", function() util.format.format({ force = true }) end, mode = { "n", "v" }, desc = "Format" },
  {
    "<leader>ur",
    "<cmd>nohlsearch<bar>diffupdate<bar>normal! <c-l><cr>",
    desc = "Redraw / clear hlsearch / diff update",
  },

  { "p", "_dP", mode = "v", desc = "Preserve copied content on paste" },
}

for _, mapping in ipairs(keys) do
  vim.keymap.set(
    mapping.mode or "n",
    mapping[1],
    mapping[2],
    { desc = mapping.desc, expr = mapping.expr, remap = mapping.remap }
  )
end
