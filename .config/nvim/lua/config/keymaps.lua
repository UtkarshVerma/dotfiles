local keymap = vim.keymap.set
local opts = {
	noremap = true,
	silent = true,
}

-- Remap leader as space key
vim.g.mapleader = " "
vim.g.maplocal = " "
keymap({ "n", "v" }, "<space>", "<nop>", opts)

-- Save with Ctrl+s
keymap({ "n", "i", "v" }, "<c-s>", "<cmd>w<cr>", opts)

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Prevent accidentally suspending nvim process
keymap({ "n", "v" }, "<c-z>", "<nop>", opts)
keymap({ "n", "v" }, "<c-s-z>", "<nop>", opts)

keymap("i", "<c-bs>", "<c-w>", opts)
keymap("i", "<c-del>", "<c-o>dw", opts)
keymap("i", "<c-z>", "<c-o>u", opts)
keymap("i", "<c-s-z>", "<c-o><c-r>", opts)

-- Navigate buffers
keymap({ "n", "i", "v" }, "<c-s-t>", "<cmd>e #<cr>", opts)
keymap({ "n", "i", "v" }, "<c-w>", "<cmd>bdelete<cr>", opts)
keymap({ "n", "i", "v" }, "<c-tab>", "<cmd>bnext<cr>", opts)
keymap({ "n", "i", "v" }, "<c-s-tab>", "<cmd>bprev<cr>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Single line indentation
keymap({ "n", "v", "i" }, "<esc>", "<esc>", opts) -- This is necessary as <c-]> is remapped
keymap("i", "<c-]>", "<c-t>", opts)
keymap("i", "<c-[>", "<c-d>", opts)
keymap("i", "<s-tab>", "<c-d>", opts)
keymap("n", "<c-]>", ">>", opts)
keymap("n", "<c-[>", "<<", opts)

-- Move text up and down and return to the same mode
keymap({ "n", "i" }, "<a-up>", "<cmd>m .-2<cr>", opts)
keymap({ "n", "i" }, "<a-down>", "<cmd>m .+1<cr>", opts)
keymap("v", "<a-up>", "<cmd>m '<-2<cr>gv=gv", opts)
keymap("v", "<a-down>", "<cmd>m '>+1><cr>gv=gv", opts)

keymap({ "n", "i" }, "<a-z>", "<cmd>set wrap!<cr>", opts)

-- Preserve copied content on paste
keymap("v", "p", "_dP", opts)
