return {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
        {
            "<leader>ft",
            function()
                require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
            end,
            desc = "NeoTree (root dir)",
        },
        { "<leader>fT", "<cmd>Neotree toggle<CR>", desc = "NeoTree (cwd)" },
        { "<leader>e", "<leader>ft", desc = "NeoTree (root dir)", remap = true },
        { "<leader>E", "<leader>fT", desc = "NeoTree (cwd)", remap = true },
    },
    init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
        filesystem = {
            follow_current_file = true,
            hijack_netrw_behavior = "open_current",
        },
    },
}
