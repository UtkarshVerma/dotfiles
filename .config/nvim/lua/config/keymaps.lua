-- Unset LazyVim's default bindings
vim.keymap.del("n", "<c-h>")
vim.keymap.del("n", "<c-j>")
vim.keymap.del("n", "<c-k>")
vim.keymap.del("n", "<c-l>")
vim.keymap.del("n", "<c-up>")
vim.keymap.del("n", "<c-down>")
vim.keymap.del("n", "<c-left>")
vim.keymap.del("n", "<c-right>")
vim.keymap.del({ "n", "v", "i" }, "<a-j>")
vim.keymap.del({ "n", "v", "i" }, "<a-k>")
vim.keymap.del("n", "[b")
vim.keymap.del("n", "]b")
vim.keymap.del("n", "<leader>bb")
vim.keymap.del("n", "<leader>`")

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
