return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets"
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local opts = {
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
            }),
            mapping = cmp.mapping.preset.insert({
                ["<c-d>"] = cmp.mapping.scroll_docs(-4),
                ["<c-f>"] = cmp.mapping.scroll_docs(4),
                ["<c-space>"] = cmp.mapping.complete(),
                ["<cr>"] = cmp.mapping.confirm({
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                }),
                ["<tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<s-tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
        }
        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup(opts)

        vim.opt.completeopt = { "menuone", "noselect" }
    end
}
