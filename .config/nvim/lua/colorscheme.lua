-- vim.g.molokai_dev = true
vim.g.molokai_transparent       = true
vim.g.molokai_transparent_float = true

local status_ok, _ = pcall(vim.cmd, "colorscheme molokai")
if not status_ok then
    vim.notify("error: could not load colorscheme")
    return
end
