local status_ok, lsp_signature = pcall(require, "lsp_signature")
if not status_ok then
    return
end

lsp_signature.setup({
    floating_window = false,
    handler_opts = {
        border = "none"
    },
    doc_lines = 0,
    padding = " ",

    hint_enable = true,
    hint_prefix = " ",
    hint_scheme = "DiagnosticInfo"
})
