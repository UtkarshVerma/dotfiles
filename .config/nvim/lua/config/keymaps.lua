-- Unset LazyVim's default bindings
vim.keymap.set("n", "<c-h>", "<nop>")
vim.keymap.set("n", "<c-j>", "<nop>")
vim.keymap.set("n", "<c-k>", "<nop>")
vim.keymap.set("n", "<c-l>", "<nop>")
vim.keymap.set("n", "<c-up>", "<nop>")
vim.keymap.set("n", "<c-down>", "<nop>")
vim.keymap.set("n", "<c-left>", "<nop>")
vim.keymap.set("n", "<c-right>", "<nop>")
vim.keymap.set("n", "<a-j>", "<nop>")
vim.keymap.set("v", "<a-j>", "<nop>")
vim.keymap.set("i", "<a-j>", "<nop>")
vim.keymap.set("n", "<a-k>", "<nop>")
vim.keymap.set("v", "<a-k>", "<nop>")
vim.keymap.set("i", "<a-k>", "<nop>")
vim.keymap.set("n", "[b", "<nop>")
vim.keymap.set("n", "]b", "<nop>")
vim.keymap.set("n", "<leader>bb", "<nop>")
vim.keymap.set("n", "<leader>`", "<nop>")

local Util = require("lazyvim.util")

-- Better up/down
vim.keymap.set("n", "<down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "<up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- buffers
if Util.has("nvim-bufferline.lua") then
  vim.keymap.set("n", "<c-s-tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<c-tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  vim.keymap.set("n", "<c-s-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<c-tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
vim.keymap.set("n", "<c-s-t>", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Preserve copied content on paste
vim.keymap.set("v", "p", "_dP", { silent = true, noremap = true })
