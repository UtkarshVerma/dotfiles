local status_ok, cmp = pcall(require, "cmp")
if not status_ok then
    return
end

local opts = {
    mapping = cmp.mapping.preset.insert({
        ["<c-d>"] = cmp.mapping.scroll_docs(-4),
        ["<c-f>"] = cmp.mapping.scroll_docs(4),
        ["<c-space>"] = cmp.mapping.complete(),
        ["<c-e>"] = cmp.mapping.close(),
        ["<tab>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        }),
        ["<cr>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
        }),
    }),
    window = {
        completion = {
            winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:None"
        },
        documentation = {
            winhighlight = "NormalFloat:CmpDocumentation,FloatBorder:CmpDocumentationBorder"
        }
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" }
    }),
}

local plugins = {
    "lspkind",
    "luasnip"
}
for _, plugin in ipairs(plugins) do
    local plugin_opts = require("completions." .. plugin)
    for k, v in pairs(plugin_opts) do
        opts[k] = v
    end
end

cmp.setup(opts)
