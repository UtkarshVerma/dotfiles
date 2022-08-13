-- mason-lspconfig has to be set-up before nvim-lspconfig for automatic
-- installation of LSP servers
local status_ok, mason = pcall(require, "mason")
if status_ok then
    mason.setup()

    local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if status_ok then
        mason_lspconfig.setup({
            automatic_installation = true
        })
    end
end

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
lspconfig.pyright.setup({})
lspconfig.gopls.setup({})
lspconfig.clangd.setup({}) -- formatting is handled by null-ls
