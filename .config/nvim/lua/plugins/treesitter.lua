local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

configs.setup({
    ensure_installed = {
        "c",
        "cpp",
        "python",
        "rust",
        "markdown",
        "go",
        "latex",
        "lua",
        "bash",
        "commonlisp"
    },
    sync_install = false, -- Don't install parsers synchronously
    ignore_install = {}, -- List of parsers to ignore installing
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
    autotag = {
        enable = true
    },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {},         -- table of hex strings
        -- termcolors = {}      -- table of colour name strings
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        }
    }
})

-- Code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldtext = "getline(v:foldstart).'...'.trim(getline(v:foldend))"
vim.opt.fillchars = { fold = " " }
vim.opt.foldnestmax = 3
vim.opt.foldlevelstart = 99
