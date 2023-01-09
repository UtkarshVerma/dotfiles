local servers = {
    clangd = {
        -- Auto-format only if .clang-format exists
        cmd = { "clangd", "--fallback-style=none" },
    },
    sumneko_lua = {
        settings = {
            Lua = {
                telemetry = { enable = false },
                workspace = { checkThirdParty = false },
            },
        },
    },
    lemminx = {
        settings = {
            xml = {
                catalogs = { "/etc/xml/catalog" }
            }
        }
    },
    pyright = {},
    bashls = {},
    gopls = {},
    rust_analyzer = {},
    rome = {},
}

local function on_attach(client, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")

    local status_ok, telescope = pcall(require, "telescope.builtin")
    if status_ok then
        nmap("gr", telescope.lsp_references, "[G]oto [R]eferences")
        nmap("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    end

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

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

local icons = require("icons")
local signs = {
    Error = icons.diagnostics.Error,
    Warn = icons.diagnostics.Warning,
    Hint = icons.diagnostics.Hint,
    Info = icons.diagnostics.Information
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "folke/neodev.nvim", config = true },
            { "williamboman/mason.nvim", config = true },
            { "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if status_ok then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            -- Tell the server the capability of foldingRange for nvim-ufo
            -- Neovim hasn"t added foldingRange to default capabilities, users must add it manually
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }

            local lspconfig = require("lspconfig")
            for server, _ in pairs(servers) do
                local opts = {
                    on_attach = on_attach,
                    capabilities = capabilities
                }

                for key, value in pairs(servers[server]) do
                    opts[key] = value
                end
                lspconfig[server].setup(opts)
            end
        end
    },
    { "j-hui/fidget.nvim", opts = { text = { spinner = "dots" }, window = { blend = 0 } } },
}
