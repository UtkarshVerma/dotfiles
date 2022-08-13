-- Load LSP configs
local paths = vim.api.nvim_get_runtime_file("lua/lsp/*.lua", true)
for _, path in ipairs(paths) do
    local config = path:gsub(".*/lua/(.*)%.lua", "%1")
    if config ~= "lsp/init" and config ~= "lsp/common" then
        require(config)
    end
end
