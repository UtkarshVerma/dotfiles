local util = require("util")
local keymap = vim.keymap.set
local opts = {
  noremap = true,
  silent = true,
}

-- Better up/down
keymap("n", "<down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap("n", "<up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Delete words using Ctrl+BS/Del
keymap("i", "<c-bs>", "<c-w>", { silent = true, remap = true })
keymap("i", "<c-del>", "<c-o>dw", { silent = true, remap = true })

-- -- Move to window using the <ctrl> hjkl keys
-- vim.keymap.set("n", "<c-h>", "<c-w>h", { desc = "Go to left window" })
-- vim.keymap.set("n", "<c-j>", "<c-w>j", { desc = "Go to lower window" })
-- vim.keymap.set("n", "<c-k>", "<c-w>k", { desc = "Go to upper window" })
-- vim.keymap.set("n", "<c-l>", "<c-w>l", { desc = "Go to right window" })

-- Resize window using <ctrl> arrow keys
-- vim.keymap.set("n", "<c-up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
-- vim.keymap.set("n", "<c-down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
-- vim.keymap.set("n", "<c-left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
-- vim.keymap.set("n", "<c-right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- buffers
if not util.has("nvim-bufferline.lua") then
  -- Navigate buffers
  keymap({ "n", "i", "v" }, "<c-tab>", "<cmd>bnext<cr>", opts)
  keymap({ "n", "i", "v" }, "<c-s-tab>", "<cmd>bprev<cr>", opts)
  -- vim.keymap.set("n", "<s-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  -- vim.keymap.set("n", "<s-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  -- vim.keymap.set("n", "<leader>b[", "<cmd>bprevious<cr>", { desc = "Previous" })
  -- vim.keymap.set("n", "<leader>b]", "<cmd>bnext<cr>", { desc = "Next" })
end
keymap({ "n", "i", "v" }, "<c-s-t>", "<cmd>e #<cr>", opts)
keymap({ "n", "i", "v" }, "<c-w>", "<cmd>bdelete<cr>", opts)
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

-- save file
vim.keymap.set({ "i", "v", "n", "s" }, "<c-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open Quickfix List" })

-- stylua: ignore start

-- toggle options
vim.keymap.set("n", "<leader>uf", require("plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
vim.keymap.set("n", "<leader>us", function() util.toggle("spell") end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>uw", function() util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
vim.keymap.set("n", "<leader>ul", function() util.toggle("relativenumber", true) util.toggle("number") end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>ud", util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set("n", "<leader>uc", function() util.toggle("conceallevel", false, { 0, conceallevel }) end, { desc = "Toggle Conceal" })

-- lazygit
vim.keymap.set("n", "<leader>gg", function() util.float_term({ "lazygit" }) end, { desc = "Lazygit (cwd)" })
vim.keymap.set("n", "<leader>gG", function() util.float_term({ "lazygit" }, { cwd = util.get_root() }) end, { desc = "Lazygit (root dir)" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Position" })
end

-- floating terminal
vim.keymap.set("n", "<leader>ft", function() util.float_term(nil, { cwd = util.get_root() }) end, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<leader>fT", function() util.float_term() end, { desc = "Terminal (cwd)" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", {desc = "Enter Normal Mode"})

-- windows
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous" })

-- Preserve copied content on paste
keymap("v", "p", "_dP", opts)
