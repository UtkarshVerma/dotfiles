return {
    "UtkarshVerma/molokai.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
        vim.g.molokai_dev               = true
        vim.g.molokai_transparent       = true
        vim.g.molokai_transparent_float = true
        vim.cmd("colorscheme molokai")
    end
}
