local status_ok, lspsaga = pcall(require, "lspsaga")
if not status_ok then
    return
end

lspsaga.init_lsp_saga({
    server_filetype_map = {}
})

local opts = {
    noremap = true,
    silent = true
}

vim.keymap.set("n", "<c-j>", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
vim.keymap.set("n", "gd", "<cmd>Lspsaga lsp_finder<cr>", opts)
vim.keymap.set("i", "<c-k>", "<cmd>Lspsaga signature_helper<cr>", opts)
vim.keymap.set("n", "gp", "<cmd>Lspsaga preview_definition<cr>", opts)
vim.keymap.set("n", "gr", "<cmd>Lspsaga rename<cr>", opts)
