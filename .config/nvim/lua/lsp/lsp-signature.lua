local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
    return
end

lsp_signature.setup({
    hint_enable = false
})
