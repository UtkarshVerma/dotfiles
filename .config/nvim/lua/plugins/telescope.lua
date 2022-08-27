local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    return
end

local actions = require("telescope.actions")

function telescope_buffer_dir()
    return vim.fn.expand("%:p:h")
end

local fb_actions = telescope.extensions.file_browser.actions

telescope.setup({
    defaults = {
        mappings = {
            n = {
                ["q"] = actions.close
            }
        },
        extensions = {
            file_browser = {
                theme = "dropdown",
                -- use telescope instead of netrw
                hijack_netrw = true,
                mappings = {
                    ["i"] = {
                        ["<c-w>"] = function() vim.cmd("normal vbd") end
                    },
                    ["n"] = {
                        ["N"] = fb_actions.create,
                        ["h"] = fb_actions.goto_parent_dir,
                        ["/"] = function() vim.cmd("startinsert") end
                    }
                }
            }
        }
    }
})

telescope.load_extension("file_browser")

local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}
keymap("n", "<leader>f",
    "<cmd>lua require('telescope.builtin').find_files({ no_ignore = false, hidden = true })<cr>", opts)
keymap("n", "<leader>r",
    "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
keymap("n", "<leader>b",
    "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
keymap("n", "<leader>t",
    "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
keymap("n", "<leader><leader>",
    "<cmd>lua require('telescope.builtin').resume()<cr>", opts)
keymap("n", "<leader>e",
    "<cmd>lua require('telescope.builtin').diagnostics()<cr>", opts)
keymap("n", "<leader>s",
    "<cmd>lua require('telescope').extensions.file_browser.file_browser({ path = '%:p:h', cwd = telescope_buffer_dir(), repect_git_ignore = false, hidden = true, grouped = true, previewer = false, initial_mode = 'normal', layout_config = { height = 40} })<cr>"
    , opts)
