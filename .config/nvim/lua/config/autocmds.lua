local util = require("util")

---@type {[1]: util.autocommand.event, [2]: util.autocommand.opts}[]
local autocommands = {
  {
    { "FocusGained", "TermClose", "TermLeave" },
    { desc = "Reload file if it was modified in the background", command = "checktime" },
  },

  {
    "TextYankPost",
    {
      desc = "Highlight on yank",
      callback = function()
        vim.highlight.on_yank()
      end,
    },
  },

  {
    "VimResized",
    {
      desc = "Resize splits on window resize",
      callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
      end,
    },
  },

  {
    "BufReadPost",
    {
      desc = "Go to last line of code when opening a buffer",
      callback = function(arg)
        local exclude = { "gitcommit" }
        local buf = arg.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
          return
        end

        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end,
    },
  },

  {
    "FileType",
    {
      desc = "Close with q",
      pattern = {
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
      },
      callback = function(arg)
        vim.bo[arg.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = arg.buf, silent = true })
      end,
    },
  },
  {
    "FileType",
    {
      desc = "Wrap and check for spell in text files",
      pattern = { "gitcommit", "markdown" },
      callback = function(_)
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
      end,
    },
  },
  {
    "BufWritePre",
    {
      desc = "Auto create parent directories when they don't exist",
      callback = function(arg)
        if arg.match:match("^%w%w+://") then
          return
        end

        local file = vim.loop.fs_realpath(arg.match) or arg.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
      end,
    },
  },

  {
    "VimLeave",
    { desc = "Restore default cursor on exit", command = "set guicursor= | call chansend(v:stderr, '\x1b[ q')" },
  },
}

for _, autocommand in ipairs(autocommands) do
  util.create_autocmd(autocommand[1], autocommand[2])
end
