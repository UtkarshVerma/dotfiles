local keymap = vim.keymap.set
local opts = {
	noremap = true,
	silent = true,
}

-- Remap leader as space key
keymap("", "<space>", "<nop>", opts)
vim.g.mapleader = " "
vim.g.maplocal = " "

-- Navigate buffers
keymap("n", "<c-s-t>", "<cmd>e #<cr>", opts)
keymap("n", "<c-w>", "<cmd>bdelete<cr>", opts)
keymap("n", "<c-tab>", "<cmd>bnext<cr>", opts)
keymap("n", "<c-s-tab>", "<cmd>bprev<cr>", opts)
keymap("i", "<c-tab>", "<cmd>bnext<cr>", opts)
keymap("i", "<c-s-tab>", "<cmd>bprev<cr>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Single line indentation
keymap("i", "<c-]>", "<c-t>", opts)
keymap("i", "<c-[>", "<c-d>", opts)
keymap("n", "<c-]>", ">>", opts)
keymap("n", "<c-[>", "<<", opts)

-- Move text up and down and return to the same mode
keymap("n", "<a-up>", "<cmd>m .-2<cr>", opts)
keymap("n", "<a-down>", "<cmd>m .+1<cr>", opts)
keymap("i", "<a-up>", "<cmd>m .-2<cr>", opts)
keymap("i", "<a-down>", "<cmd>m .+1<cr>", opts)
keymap("v", "<a-up>", "<cmd>m '<-2<cr>gv=gv", opts)
keymap("v", "<a-down>", "<cmd>m '>+1><cr>gv=gv", opts)

-- Preserve copied content on paste
keymap("v", "p", "_dP", opts)
