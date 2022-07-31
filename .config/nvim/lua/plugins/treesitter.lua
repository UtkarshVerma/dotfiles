local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup {
    ensure_installed = {
        "c",
        "python",
        "rust",
        "go",
        "lua",
        "bash"
    },
    sync_install = false,               -- Don't install parsers synchronously
    ignore_install = {},                -- List of parsers to ignore installing
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = true
    },
    indent = {
        enable = true,
        disable = {}
    },
    autopairs = {
        enable = true
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true,   -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil,   -- Do not enable for files with more than n lines, int
        -- colors = {},         -- table of hex strings
        -- termcolors = {}      -- table of colour name strings
    }
}
