local status_ok, lspkind = pcall(require, "lspkind")
if not status_ok then
    return
end

return {
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50
        })
    }
}
