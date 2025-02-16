---@class config.keymap
---@field [1] string
---@field [2] string|fun()
---@field mode? string|string[]
---@field expr? boolean
---@field desc? string

---@type config.keymap[]
local keymaps = {
  { "j", "v:count == 0 ? 'gj' : 'j'", mode = { "n", "x" }, expr = true, desc = "Better up" },
  { "k", "v:count == 0 ? 'gk' : 'k'", mode = { "n", "x" }, expr = true, desc = "Better down" },

  { "<leader>bb", "<cmd>e #<cr>", desc = "Switch to other buffer" },
  { "<leader><leader>", "<cmd>e #<cr>", desc = "Switch to other buffer" },

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

  { "<leader>ui", vim.show_pos, desc = "Inspect position" },
  { "<leader>ul", "<cmd>Lazy<cr>", desc = "Lazy" },
  { "<leader>qq", "<cmd>qa<cr>", desc = "Quit" },

  -- Terminal mappings
  { "<esc><esc>", "<c-\\><c-n>", mode = "t", desc = "Enter normal mode" },
  { "<c-/>", "<cmd>close<cr>", mode = "t", desc = "Hide terminal" },

  -- Windows
  { "<leader>ww", "<cmd>wincmd w<cr>", desc = "Other window" },
  { "<leader>wd", "<cmd>close<cr>", desc = "Delete window" },
  { "<leader>wk", "<cmd>leftabove split<cr>", desc = "Split window top" },
  { "<leader>wl", "<cmd>rightbelow vsplit<cr>", desc = "Split window right" },
  { "<leader>wj", "<cmd>rightbelow split<cr>", desc = "Split window below" },
  { "<leader>wh", "<cmd>leftabove vsplit<cr>", desc = "Split window left" },

  -- Tabs
  { "<leader><tab>n", "<cmd>tabnew<cr>", desc = "New tab" },
  { "<leader><tab>d", "<cmd>tabclose<cr>", desc = "Close tab" },
  { "<leader><tab>l", "<cmd>tabnext<cr>", desc = "Next tab" },
  { "<leader><tab>h", "<cmd>tabprevious<cr>", desc = "Previous tab" },

  -- Diagnostics
  { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
  { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },

  {
    "<leader>ur",
    "<cmd>nohlsearch<bar>diffupdate<bar>normal!<c-l><cr>",
    desc = "Redraw / clear hlsearch / diff update",
  },

  { "p", "_dP", mode = "v", desc = "Preserve copied content on paste" },
}

---@param keymap config.keymap
vim.iter(keymaps):each(function(keymap)
  ---@type vim.keymap.set.Opts
  local opts = {
    expr = keymap.expr,
    desc = keymap.desc,
    silent = true,
  }

  vim.keymap.set(keymap.mode or "n", keymap[1], keymap[2], opts)
end)
