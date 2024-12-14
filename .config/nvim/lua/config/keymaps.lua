local util = require("util")

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3

--- Go to next or previous diagnostic of severity {severity} based on {direction}.
---@param direction "next"|"prev"
---@param severity vim.diagnostic.Severity?
---@return fun()
local function goto_diagnostic(direction, severity)
  local go = direction == "next" and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil

  return function()
    go({ severity = severity })
  end
end

---@type LazyKeysSpec[]
local keys = {
  { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, desc = "Better up", expr = true },
  { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, desc = "Better down", expr = true },

  { "<c-up>", "<cmd>resize +2<cr>", desc = "Increase window height" },
  { "<c-down>", "<cmd>resize -2<cr>", desc = "Decrease window height" },
  { "<c-left>", "<cmd>vertical resize -2<cr>", desc = "Decrease window width" },
  { "<c-right>", "<cmd>vertical resize +2<cr>", desc = "Increase window width" },

  { "<s-h>", "<cmd>bprevious<cr>", desc = "Previous buffer" },
  { "<s-l>", "<cmd>bnext<cr>", desc = "Next buffer" },
  { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to other buffer" },

  { "<esc>", "<cmd>noh<cr><esc>", mode = { "i", "n" }, desc = "Escape and clear hlsearch" },
  { "<c-s>", "<cmd>w<cr><esc>", mode = { "i", "x", "n", "s" }, desc = "Save file" },

  -- Saner behavior of n and N.
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  { "n", "'Nn'[v:searchforward].'zv'", expr = true, desc = "Next search result" },
  { "n", "'Nn'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Next search result" },
  { "N", "'nN'[v:searchforward].'zv'", expr = true, desc = "Previous search result" },
  { "N", "'nN'[v:searchforward]", mode = { "x", "o" }, expr = true, desc = "Previous search result" },

  { "<leader>xl", "<cmd>lopen<cr>", desc = "Location list" },
  { "<leader>xq", "<cmd>copen<cr>", desc = "Quickfix list" },
  { "[q", "<cmd>cprev<cr>", desc = "Previous quickfix" },
  { "]q", "<cmd>cnext<cr>", desc = "Next quickfix" },

  {
    "<leader>gl",
    function()
      util.terminal.open({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
    end,
    desc = "Lazygit",
  },

  { "<leader>ui", vim.show_pos, desc = "Inspect position" },
  { "<leader>ul", "<cmd>Lazy<cr>", desc = "Lazy" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit" },

  -- stylua: ignore start
  { "<leader>tt", function() util.terminal.open() end, desc = "Terminal" },
  { "<leader>ts", function() util.toggle.option("spell") end, desc = "Spelling" },
  { "<leader>tw", function() util.toggle.option("wrap") end, desc = "Word wrap" },
  { "<leader>td", util.toggle.diagnostics, desc = "Diagnostics" },
  { "<leader>tc", function() util.toggle.option("conceallevel", { 0, conceallevel }) end, desc = "Conceal" },
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

  -- Tabs
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close tab" },
  { "<leader><tab>l", "<cmd>tabnext<cr>", desc = "Next tab" },
  { "<leader><tab>h", "<cmd>tabprevious<cr>", desc = "Previous tab" },

  -- Diagnostics
  { "]d", goto_diagnostic("next"), desc = "Next diagnostic" },
  { "[d", goto_diagnostic("prev"), desc = "Previous diagnostic" },

  -- Inlay hints
  -- stylua: ignore
  { "<leader>ti", function() util.toggle.inlay_hints(0) end, desc = "Inlay hints" },

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
