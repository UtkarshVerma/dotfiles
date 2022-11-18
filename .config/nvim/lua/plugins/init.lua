local plugins = {
    "impatient", -- has to be at the top
    "alpha",
    "autopairs",
    "autotag",
    "bufferline",
    "colorizer",
    "comment",
    "git",
    "gitsigns",
    "indent-blankline",
    "lualine",
    "packer",
    "telescope",
    "treesitter",
    "vimtex",
    "vimwiki",
    "vim-table-mode",
    "web-devicons"
}

for _, plugin in ipairs(plugins) do
    local status_ok, _ = pcall(require, "plugins." .. plugin)
    if not status_ok then
        vim.notify("error: could not load plugin " .. plugin .. "!")
    end
end
