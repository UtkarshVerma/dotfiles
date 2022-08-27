local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
    return
end

local status_ok, lspkind = pcall(require, "lspkind")
if not status_ok then
    return
end

local status_ok, luasnip = pcall(require, "luasnip")
if not status_ok then
    return
end

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ["<c-d>"] = cmp.mapping.scroll_docs(-4),
        ["<c-f>"] = cmp.mapping.scroll_docs(4),
        ["<c-space>"] = cmp.mapping.complete(),
        ["<c-e>"] = cmp.mapping.close(),
        ["<cr>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        })
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" }
    }),
    formatting = {
        format = lspkind.cmp_format({
            wirth_text = false,
            maxwidth = 50
        })
    }
})

vim.cmd([[
    set completeopt=menuone,noinsert,noselect
    highlight! default link CmpItemKind CmpItemMenuDefault
]])
