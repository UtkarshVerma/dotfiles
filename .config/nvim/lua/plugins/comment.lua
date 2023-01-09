return {
    "numToStr/Comment.nvim",
    opts = {}
}


-- comment.setup({
--     mappings = {
--         basic = true,
--         extra = false,
--         extended = false
--     }
-- })
--
-- local api = require("Comment.api")
-- local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
-- local keymap = vim.keymap.set
-- local opts = {
--     noremap = true,
--     silent = true
-- }
--
-- keymap("n", "<c-/>", api.toggle.linewise.current, opts)
-- keymap("i", "<c-/>", api.toggle.linewise.current, opts)
-- keymap("v", "<c-/>", function()
--     vim.api.nvim_feedkeys(esc, "nx", false)
--
--     local first = vim.fn.getpos("'<")[2]
--     local last = vim.fn.getpos("'>")[2]
--     local n_lines = last - first
--
--     api.toggle.linewise(vim.fn.visualmode())
--     vim.api.nvim_feedkeys("gv" .. n_lines .. "j", "nx", false)
-- end)
