local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
    return
end

local function on_attach(client, bufnr)
    -- Format on save
    if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[
            augroup Format
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
        ]])
    end
end

lspconfig.sumneko_lua.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            -- -- Disable this in favour of stylua
            -- format = { enable = false },
            diagnostics = {
                -- Get the language server to recognize 'vim' global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                },
            },
        },
    },
})
lspconfig.texlab.setup({ on_attach = on_attach })
lspconfig.lemminx.setup({
    on_attach = on_attach,
    settings = {
        xml = {
            catalogs = { "/etc/xml/catalog" }
        }
    }
})
lspconfig.pyright.setup({ on_attach = on_attach })
lspconfig.bashls.setup({ on_attach = on_attach })
lspconfig.gopls.setup({ on_attach = on_attach })
lspconfig.rust_analyzer.setup({ on_attach = on_attach })
lspconfig.clangd.setup({
    on_attach = on_attach,

    -- Auto-format only if .clang-format exists
    cmd = { "clangd", "--fallback-style=none" },
})
