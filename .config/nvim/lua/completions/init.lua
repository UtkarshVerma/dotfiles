-- Load completion configs
local paths = vim.api.nvim_get_runtime_file("lua/completions/*.lua", true)
for _, path in ipairs(paths) do
    local config = path:gsub(".*/lua/(.*)%.lua", "%1")
    if config ~= "completions/init" then
        require(config)
    end
end
