-- mason-lspconfig has to be set-up before nvim-lspconfig for automatic
-- installation of LSP servers
local status_ok, mason = pcall(require, "mason")
if status_ok then
    mason.setup()

    local status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
    if status_ok then
        mason_lspconfig.setup({
            automatic_installation = true
        })
    end
end
