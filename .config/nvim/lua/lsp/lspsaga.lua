local status_ok, lspsaga = pcall(require, "lspsaga")
if not status_ok then
    return
end

lspsaga.init_lsp_saga({
    server_filetype_map = {},

    rename_action_quit = "<esc>", -- quit rename action using escape
    rename_in_select = false, -- don't select word while renaming symbol

    code_action_icon = " ",
    code_action_lightbulb = {
        virtual_text = false,
    },
})

local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts)
keymap("v", "<leader>ca", "<cmd><c-u>Lspsaga range_code_action<cr>", opts)

keymap("n", "gr", "<cmd>Lspsaga rename<cr>", opts)
keymap("n", "gd", "<cmd>Lspsaga peek_definition<cr>", opts)

keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<cr>", opts)

keymap("n", "<leader>o", "<cmd>LSoutlineToggle<cr>", opts)
keymap("n", "K", "<cmd>Lspsaga hover_doc<cr>", opts)
