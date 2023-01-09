return {
    "vimwiki/vimwiki",
    init = function()
        vim.g.vimwiki_global_ext = 0
        vim.g.vimwiki_list = {
            {
                auto_export = 0,
                path_html = '~/notes/output/',
                path = '~/notes/vimwiki/',
                syntax = 'default',
                ext = '.wiki',
            },
            {
                path = "~/notes/gsi/",
                syntax = "markdown",
                ext = ".md"
            }
        }
    end
}
