local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

-- Remap leader as space key
keymap("", "<space>", "<nop>", opts)
vim.g.mapleader = " "
vim.g.maplocal = " "

-- Navigate buffers
keymap("n", "<c-tab>", ":bnext<cr>", opts)
keymap("n", "<c-s-tab>", ":bprev<cr>", opts)
keymap("i", "<c-tab>", "<esc>:bnext<cr>", opts)
keymap("i", "<c-s-tab>", "<esc>:bprev<cr>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Single line indentation
keymap("i", "<c-]>", "<c-t>", opts)
keymap("i", "<c-[>", "<c-d>", opts)
keymap("n", "<c-]>", "gi<c-t><esc>", opts)
keymap("n", "<c-[>", "gi<c-d><esc>", opts)

-- Move text up and down and return to the same mode
keymap("n", "<a-up>", ":m .-2<cr>==", opts)
keymap("n", "<a-down>", ":m .+1<cr>==", opts)
keymap("i", "<a-up>", "<esc>:m .-2<cr>==gi", opts)
keymap("i", "<a-down>", "<esc>:m .+1<cr>==gi", opts)
keymap("v", "<a-down>", ":m '>+1><cr>gv=gv", opts)
keymap("v", "<a-up>", ":m '<-2<cr>gv=gv", opts)

-- Preserve copied content on paste
keymap("v", "p", "_dP", opts)
