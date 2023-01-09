return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    build = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            cond = vim.fn.executable("make") == 1
        }
    },
    cmd = "Telescope",
    keys = {
        { "<leader>?", "<cmd>Telescope oldfiles<cr>", desc = "[?] Find recently opened files" },
        { "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
        { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[/] Fuzzily search in current buffer]" },
        { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
        { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
        { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
        { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
        { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch [D]iagnostics" }
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local opts = {
            defaults = {
                mappings = {
                    i = {
                        ["<c-u>"] = false,
                        ["<c-d>"] = false,
                        ["<esc>"] = actions.close
                    }
                },
            }
        }
        telescope.load_extension("fzf")
        telescope.setup(opts)
    end
}
