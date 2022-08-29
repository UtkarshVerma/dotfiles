local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

local on_attach = require("lsp.common").on_attach

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
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                }
            }
        }
    }
})
lspconfig.pyright.setup({})
lspconfig.bashls.setup({})
lspconfig.gopls.setup({})
lspconfig.clangd.setup({
    -- Auto-format only if .clang-format exists
    cmd = { "clangd", "--fallback-style=none" },
    on_attach = on_attach
})
