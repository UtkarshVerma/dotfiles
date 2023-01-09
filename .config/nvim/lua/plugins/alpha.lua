return {
    enabled = false,
    "goolord/alpha-nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local dashboard = require("alpha.themes.dashboard")
        dashboard.section.header.val = {
            [[                               __                ]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
        }
        dashboard.section.buttons.val = {
            dashboard.button("f", "  Find file", "<cmd>Telescope find_files<cr>"),
            dashboard.button("e", "  New file", "<cmd>ene <bar> startinsert<cr>"),
            dashboard.button("r", "  Recently used files", "<cmd>Telescope oldfiles<cr>"),
            dashboard.button("t", "  Find text", "<cmd>Telescope live_grep<cr>"),
            dashboard.button("c", "  Configuration", "<cmd>e ~/.config/nvim/init.lua<cr>"),
            dashboard.button("q", "  Quit Neovim", "<cmd>qa<cr>"),
        }

        -- dashboard.section.footer.val = ""

        dashboard.section.footer.opts.hl = "Type"
        dashboard.section.header.opts.hl = "Include"
        dashboard.section.buttons.opts.hl = "Keyword"

        dashboard.opts.opts.noautocmd = true
        -- vim.cmd([[autocmd User AlphaReady echo 'ready']])
        require("alpha").setup(dashboard.opts)
    end
}
