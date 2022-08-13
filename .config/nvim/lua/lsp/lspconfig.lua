local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

local on_attach = require("lsp/common").on_attach

lspconfig.sumneko_lua.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize 'vim' global
                globals = { 'vim' }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
})

-- Formatting is handled by null-ls
lspconfig.clangd.setup({})
