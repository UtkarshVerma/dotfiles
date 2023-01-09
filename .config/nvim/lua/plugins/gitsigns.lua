local icons = require("icons")

return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = {
            add = { text = icons.ui.BoldLineLeft, },
            change = { text = icons.ui.BoldLineLeft },
            changedelete = { text = icons.ui.BoldLineLeft }
        }
    }
}
