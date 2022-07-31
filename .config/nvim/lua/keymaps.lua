local opts = {
    noremap = true,
    silent = true
}

local keymap = vim.api.nvim_set_keymap
-- Shorten function name

-- Remap leader as space key
keymap("", "<space>", "<nop>", opts)
vim.g.mapleader = " "
vim.g.maplocal = " "

-- Window navigation
keymap("n", "<c-h>", "<c-w>h", opts)
keymap("n", "<c-j>", "<c-w>j", opts)
keymap("n", "<c-k>", "<c-w>k", opts)
keymap("n", "<c-l>", "<c-w>l", opts)

-- Resize with arrows
--[[keymap("n", "<c-up>", ":resize +2<cr>", opts)
keymap("n", "<c-down>", ":resize -2<cr>", opts)
keymap("n", "<c-left>", ":vertical resize -2<cr>", opts)
keymap("n", "<c-right>", ":vertical resize +2<cr>", opts)
]]

-- Navigate buffers
keymap("n", "<s-l>", ":bnext<cr>", opts)
keymap("n", "<s-h>", ":bnext<cr>", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("n", "<a-j>", "<esc>:m .+1<cr>==gi", opts)
keymap("n", "<a-k>", "<esc>:m .-2<cr>==gi", opts)
keymap("v", "<a-j>", ":m .+1<cr>==", opts)
keymap("v", "<a-k>", ":m .-2<cr>==", opts)
keymap("x", "<s-j>", ":m '>+1<cr>gv-gv", opts)
keymap("x", "<s-k>", ":m '<-2<cr>gv-gv", opts)
keymap("x", "<a-j>", ":m '>+1<cr>gv-gv", opts)
keymap("x", "<a-j>", ":m '<-2<cr>gv-gv", opts)

-- Preserve copied content on paste
keymap("v", "p", "_dP", opts)
