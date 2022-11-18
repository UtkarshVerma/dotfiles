local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    return
end

require("luasnip.loaders.from_vscode").lazy_load()

return {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    }
}
