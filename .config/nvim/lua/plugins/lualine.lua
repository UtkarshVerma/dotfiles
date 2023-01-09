local icons = require("icons")

return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = {
            theme = "auto",
            component_separators = { left = "", right = icons.ui.DividerLeft },
            globalstatus = true,
            section_separators = { left = icons.ui.BoldDividerRight, right = icons.ui.BoldDividerLeft },
            disabled_filetypes = {
                statusline = {
                    "alpha",
                    "packer"
                }
            }
        },

        extensions = {
            "nvim-dap-ui",
            "nvim-tree",
            "quickfix",
            "toggleterm"
        },

        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" }
        }
    }
}
